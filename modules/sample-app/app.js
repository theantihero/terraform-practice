/**
 * Sample Node.js application with Prometheus metrics and structured logging
 * @author Terraform DevOps
 * @date 2025-01-15
 */

const express = require('express');
const prometheus = require('prom-client');
const winston = require('winston');

// Initialize Express app
const app = express();
const port = process.env.PORT || 3000;

// Initialize Prometheus metrics
const register = new prometheus.Registry();

// Add default metrics (CPU, memory, etc.)
prometheus.collectDefaultMetrics({ register });

// Custom metrics
const httpRequestsTotal = new prometheus.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'status', 'route'],
  registers: [register]
});

const httpRequestDuration = new prometheus.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route'],
  buckets: [0.001, 0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10],
  registers: [register]
});

const activeConnections = new prometheus.Gauge({
  name: 'http_active_connections',
  help: 'Number of active HTTP connections',
  registers: [register]
});

// Initialize logger
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: '/var/log/sample-app/app.log' })
  ]
});

// Middleware for metrics collection
app.use((req, res, next) => {
  const start = Date.now();
  activeConnections.inc();
  
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    httpRequestsTotal.inc({
      method: req.method,
      status: res.statusCode,
      route: req.route ? req.route.path : req.path
    });
    httpRequestDuration.observe({
      method: req.method,
      route: req.route ? req.route.path : req.path
    }, duration);
    activeConnections.dec();
  });
  
  next();
});

// Middleware for logging
app.use((req, res, next) => {
  logger.info('HTTP request', {
    method: req.method,
    url: req.url,
    userAgent: req.get('User-Agent'),
    ip: req.ip
  });
  next();
});

// Routes
app.get('/', (req, res) => {
  res.json({
    message: 'Sample Application for Observability Stack',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

app.get('/metrics', (req, res) => {
  res.set('Content-Type', register.contentType);
  register.metrics().then(data => res.send(data));
});

// Simulate some load and errors
app.get('/api/data', (req, res) => {
  // Simulate random response times
  const delay = Math.random() * 100;
  setTimeout(() => {
    // Simulate occasional errors (5% chance)
    if (Math.random() < 0.05) {
      logger.error('Simulated error occurred', {
        endpoint: '/api/data',
        error: 'Random error for demonstration'
      });
      res.status(500).json({ error: 'Internal server error' });
    } else {
      res.json({
        data: Array.from({ length: 10 }, (_, i) => ({
          id: i,
          value: Math.random() * 100,
          timestamp: new Date().toISOString()
        }))
      });
    }
  }, delay);
});

app.get('/api/load', (req, res) => {
  // Simulate high CPU load
  const start = Date.now();
  while (Date.now() - start < 100) {
    // Busy wait to simulate CPU load
  }
  res.json({ message: 'Load simulation complete' });
});

// Error handling middleware
app.use((err, req, res, next) => {
  logger.error('Unhandled error', {
    error: err.message,
    stack: err.stack,
    url: req.url,
    method: req.method
  });
  res.status(500).json({ error: 'Internal server error' });
});

// Start server
app.listen(port, '0.0.0.0', () => {
  logger.info('Sample application started', {
    port: port,
    environment: process.env.NODE_ENV || 'development'
  });
});

// Graceful shutdown
process.on('SIGTERM', () => {
  logger.info('Received SIGTERM, shutting down gracefully');
  process.exit(0);
});

process.on('SIGINT', () => {
  logger.info('Received SIGINT, shutting down gracefully');
  process.exit(0);
});
