import { DataSourceOptions } from 'typeorm';

const config: DataSourceOptions = {
  type: 'postgres',
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT),
  username: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB,
  entities: [__dirname + '/dist/**/entities/*'],
  migrationsTableName: 'schema_history',
  migrations: [__dirname + '/src/db/migrations/*.ts'],
  logNotifications: true,
  applicationName: 'nest-api',
  extra: {
    max: 10,
    connectionTimeoutMillis: 30000,
  },
};
export = config;
