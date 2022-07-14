'use strict';
import { NextFunction, Request, Response } from 'express';
import { ConsoleLogger, Injectable, NestMiddleware } from '@nestjs/common';

@Injectable()
export class LoggerMiddleware implements NestMiddleware {
  private logger = new ConsoleLogger('HTTP');

  use(request: Request, response: Response, next: NextFunction): void {
    const startAt = process.hrtime();
    const { method, originalUrl } = request;

    response.on('finish', () => {
      const { statusCode } = response;
      const diff = process.hrtime(startAt);
      const responseTime = diff[0] * 1e3 + Math.round(diff[1] * 1e-6);
      this.logger.log(
        `${method} ${originalUrl} ${statusCode} ${responseTime}ms`,
      );
    });

    next();
  }
}
