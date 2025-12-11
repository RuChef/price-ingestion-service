package com.ruchef.priceprocessor.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Конфигурация путей к папкам приложения.
 * Значения берутся из application.yml по префиксу app.folders
 */
@Getter
@Setter
@Configuration
@ConfigurationProperties(prefix = "app.folders")
public class AppFoldersConfig {

    private String incoming;
    private String processed;
    private String archive;
    private String error;

    // Удобные методы — возвращают Path (то, что нужно WatchService)
    public Path getIncomingPath() {
        return Paths.get(incoming);
    }

    public Path getProcessedPath() {
        return Paths.get(processed);
    }

    public Path getArchivePath() {
        return Paths.get(archive);
    }

    public Path getErrorPath() {
        return Paths.get(error);
    }
}