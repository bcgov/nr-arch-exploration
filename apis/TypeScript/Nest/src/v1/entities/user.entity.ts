import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';
import { Field, ObjectType } from '@nestjs/graphql';

@Entity('USER')
@ObjectType()
export class User {
  @PrimaryGeneratedColumn('uuid', { name: 'user_id' })
  @Field()
  userId: string;

  @Field()
  @Column({ name: 'first_name' })
  firstName: string;

  @Field()
  @Column({ name: 'last_name' })
  lastName: string;

  @Field()
  @Column()
  email: string;

  @Field()
  @Column({ name: 'phone_number' })
  phoneNumber: string;

  @Field()
  @Column({ name: 'hire_date', type: 'date' })
  hire_date: Date;

  @Field()
  @Column()
  salary: number;
}
