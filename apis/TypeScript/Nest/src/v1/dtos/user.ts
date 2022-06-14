import { Field, InputType } from '@nestjs/graphql';

@InputType()
export class UserDTO {
  @Field({ nullable: true })
  userId: string;

  @Field()
  firstName: string;

  @Field()
  lastName: string;

  @Field()
  email: string;

  @Field()
  phoneNumber: string;

  @Field()
  hire_date: Date;

  @Field({ nullable: true })
  salary: number;
}
