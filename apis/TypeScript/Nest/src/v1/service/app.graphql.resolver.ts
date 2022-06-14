import { AppGraphqlService } from './app.graphql.service';
import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { User } from '../entities/user.entity';
import { UserDTO } from '../dtos/user';
import { Public } from 'nest-keycloak-connect';
@Resolver((of) => User)
@Public()
export class AppGraphqlResolver {
  constructor(private readonly gqlService: AppGraphqlService) {}

  @Query((returns) => User)
  async getUserById(@Args('id') id: string): Promise<User> {
    return this.gqlService.findOne(id);
  }

  @Mutation((returns) => User)
  async addUser(@Args('user') user: UserDTO): Promise<User> {
    return await this.gqlService.save(user);
  }

  @Mutation((returns) => Boolean)
  async removeUser(@Args('id') id: string) {
    return this.gqlService.remove(id);
  }
}
