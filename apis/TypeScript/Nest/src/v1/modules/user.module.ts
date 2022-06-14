import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from '../entities/user.entity';
import { AppGraphqlResolver } from '../service/app.graphql.resolver';
import { AppGraphqlService } from '../service/app.graphql.service';

@Module({
  imports: [TypeOrmModule.forFeature([User])],
  exports: [TypeOrmModule],
  providers: [AppGraphqlResolver, AppGraphqlService],
})
export class UsersModule {}
