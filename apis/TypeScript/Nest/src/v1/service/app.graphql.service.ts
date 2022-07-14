import { Controller, Injectable, Logger } from '@nestjs/common';
import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { randomUUID } from 'crypto';
import { GraphQLError } from 'graphql';
import { Roles } from 'nest-keycloak-connect';
import { ApiBearerAuth } from '@nestjs/swagger';

@Injectable()
@ApiBearerAuth()
@Controller()
export class AppGraphqlService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
  ) {}

  @Roles({ roles: [] })
  async findOne(userId: string): Promise<User> {
    const user = await this.usersRepository.findOneBy({ userId: userId });
    if (user) {
      return user;
    } else {
      throw new GraphQLError(`User with id ${userId} could not be found`);
    }
  }

  @Roles({ roles: [] })
  async save(user: User): Promise<User> {
    try {
      const userModel: User = {
        ...user,
        userId: randomUUID(),
      };

      return await this.usersRepository.save(userModel);
    } catch (err) {
      Logger.error(err);
      throw new GraphQLError(`User could not be found`);
      // since we have errors lets rollback the changes we made
    } finally {
      // you need to release a queryRunner which was manually instantiated
    }
  }

  @Roles({ roles: [] })
  async remove(userId: string): Promise<User> {
    const user = await this.usersRepository.findOneBy({ userId: userId });
    if (user) {
      return this.usersRepository.remove(user);
    } else {
      throw new GraphQLError(`User with id ${userId} could not be found`);
    }
  }
}
