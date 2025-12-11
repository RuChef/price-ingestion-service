package com.ruchef.priceprocessor.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.nio.file.Path;

@Configuration
@ConfigurationProperties(prefix = "app.folders")
public class AppConfig {
    private String incoming;
    private String processed;
    private String archive;
    private String error;

    // геттеры и сеттеры (Lombok потом заменим)
    public Path getIncomingPath() { return Path.of(incoming); }
    public Path getProcessedPath() { return Path.of(processed); }
    public Path getArchivePath() { return Path.of(archive); }
    public Path getErrorPath() { return Path.of(error); }

    // ... остальные геттеры/сеттеры
}