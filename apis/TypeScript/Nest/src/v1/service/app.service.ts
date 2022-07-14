import { HttpException, HttpStatus, Injectable, Logger } from '@nestjs/common';
import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { randomUUID } from 'crypto';

@Injectable()
export class AppService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
  ) {}

  async findOne(userId: string): Promise<User> {
    const user = await this.usersRepository.findOneBy({ userId: userId });
    if (user) {
      return user;
    } else {
      throw new HttpException(
        `User with id '${userId}' is not found.`,
        HttpStatus.NOT_FOUND,
      );
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
      // since we have errors lets rollback the changes we made
    } finally {
      // you need to release a queryRunner which was manually instantiated
    }
  }

  async remove(userId: string): Promise<void> {
    const user = await this.usersRepository.findOneBy({ userId: userId });
    if (user) {
      await this.usersRepository.remove(user);
    } else {
      throw new HttpException(
        `User with id '${userId}' is not found.`,
        HttpStatus.NOT_FOUND,
      );
    }
  }
}
