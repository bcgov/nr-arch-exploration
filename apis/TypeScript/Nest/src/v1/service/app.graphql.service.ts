import { Injectable, Logger } from '@nestjs/common';
import { Connection, Repository } from 'typeorm';
import { User } from '../entities/user.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { randomUUID } from 'crypto';
import { GraphQLError } from 'graphql';

@Injectable()
export class AppGraphqlService {
  constructor(
    private readonly connection: Connection,
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
  ) {}

  async findOne(id: string): Promise<User> {
    const user = await this.usersRepository.findOne(id);
    if (user) {
      return user;
    } else {
      throw new GraphQLError(`User with id ${id} could not be found`);
    }
  }

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

  async remove(id: string): Promise<User> {
    const user = await this.usersRepository.findOne(id);
    if (user) {
      return await this.usersRepository.remove(user);
    } else {
      throw new GraphQLError(`User with id ${id} could not be found`);
    }
  }
}
