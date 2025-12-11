package com.ruchef.priceprocessor.service;

import com.ruchef.priceprocessor.config.AppFoldersConfig;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Сервис, который следит за папкой ./incoming
 * Как только появляется новый файл — выводим в лог и можем дальше обрабатывать.
 * Работает в отдельном потоке, не блокирует основной запуск приложения.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class DirectoryWatcherService {

    private final AppFoldersConfig foldersConfig;

    // Один поток — достаточно для мониторинга одной папки
    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    @PostConstruct
    public void startWatching() {
        executor.submit(this::watchDirectory);
    }

    @PreDestroy
    public void shutdown() {
        executor.shutdown();
    }

    private void watchDirectory() {
        Path dir = foldersConfig.getIncomingPath();

        // Создаём папку, если её нет
        try {
            Files.createDirectories(dir);
            log.info("Папка для входящих прайсов создана/найдена: {}", dir.toAbsolutePath());
        } catch (IOException e) {
            log.error("Не удалось создать папку incoming: {}", dir, e);
            return;
        }

        try (WatchService watchService = FileSystems.getDefault().newWatchService()) {

            // Слушаем только создание новых файлов
            dir.register(watchService, StandardWatchEventKinds.ENTRY_CREATE);

            log.info("Запущен мониторинг папки: {}", dir.toAbsolutePath());
            log.info("Кидай сюда любой .xlsx или .xls файл — я увижу!");

            while (!Thread.currentThread().isInterrupted()) {
                WatchKey key = watchService.take(); // блокируется, пока не появится файл

                for (WatchEvent<?> event : key.pollEvents()) {
                    WatchEvent.Kind<?> kind = event.kind();

                    if (kind == StandardWatchEventKinds.OVERFLOW) {
                        continue;
                    }

                    @SuppressWarnings("unchecked")
                    WatchEvent<Path> pathEvent = (WatchEvent<Path>) event;
                    Path filename = pathEvent.context();

                    // Обрабатываем только Excel-файлы
                    if (filename.toString().toLowerCase().endsWith(".xlsx") ||
                        filename.toString().toLowerCase().endsWith(".xls")) {

                        Path fullPath = dir.resolve(filename);

                        log.info("Обнаружен новый прайс-лист!");
                        log.info("Файл: {}", fullPath.toAbsolutePath());
                        log.info("Размер: {} КБ", Files.size(fullPath) / 1024);

                        // Здесь будет вызов обработки — пока просто лог
                        log.info("Файл отправлен в обработку... (пока заглушка)");
                    }
                }

                boolean valid = key.reset();
                if (!valid) {
                    break; // папка удалена или недоступна
                }
            }

        } catch (IOException e) {
            log.error("Ошибка при создании WatchService", e);
        } catch (InterruptedException e) {
            log.info("Мониторинг папки остановлен");
            Thread.currentThread().interrupt();
        }
    }
}