import { Test, TestingModule } from '@nestjs/testing';
import { AppControllerV1 } from '../../../src/v1/controllers/app.controller';
import { AppService } from '../../../src/v1/service/app.service';
import { User } from '../../../src/v1/entities/user.entity';

describe('AppController', () => {
  let app: TestingModule;
  let controller: AppControllerV1;
  let service: AppService;
  afterEach(() => {
    jest.clearAllMocks();
  });
  const mockResponse = () => {
    const res: any = { data: {} };
    res.status = jest.fn().mockImplementation((v) => {
      res.data.status = v;
      return res;
    });
    res.json = jest.fn().mockImplementation((v) => {
      res.data.json = v;
      return res;
    });
    res.redirect = jest.fn().mockReturnValue(res);
    res.send = jest.fn().mockImplementation((v) => {
      res.data.raw = v;
      return res;
    });
    res.setHeader = jest.fn().mockReturnValue(res);
    return res;
  };
  const user = new User();
  user.firstName = 'John';
  user.lastName = 'Doe';
  user.email = 'test@gmail.com';
  user.phoneNumber = '1234567890';
  user.hire_date = new Date();
  user.salary = 1000;
  beforeEach(async () => {
    app = await Test.createTestingModule({
      controllers: [AppControllerV1],
      providers: [
        AppService,
        {
          provide: AppService,
          useValue: {
            AppService: jest
              .fn()
              .mockImplementation((user: User) =>
                Promise.resolve({ id: '1', ...user }),
              ),
            findOne: jest.fn().mockImplementation((id: string) =>
              Promise.resolve({
                firstName: 'firstName #1',
                lastName: 'lastName #1',
                userId: id,
              }),
            ),
            save: jest.fn().mockImplementation((user: User) =>
              Promise.resolve({
                firstName: user.firstName,
                lastName: user.lastName,
                userId: '1',
              }),
            ),
            remove: jest.fn(),
          },
        },
      ],
    }).compile();
    controller = app.get<AppControllerV1>(AppControllerV1);
    service = app.get<AppService>(AppService);
  });

  describe('findOne', () => {
    it('given id exist should find a user', () => {
      expect(controller.getUserByID('1')).resolves.toEqual({
        firstName: 'firstName #1',
        lastName: 'lastName #1',
        userId: '1',
      });
      expect(service.findOne).toHaveBeenCalled();
    });
    it('given id does not exist should not find a user', async () => {
      try {
        await controller.getUserByID('2');
      } catch (e) {
        expect(e.message).toBe('User not found');
      }
    });
  });
  describe('create', () => {
    it('given valid payload should create a user', () => {
      expect(controller.create(user, mockResponse())).resolves.toEqual({
        firstName: user.firstName,
        lastName: user.lastName,
        userId: '1',
      });
      expect(service.save).toHaveBeenCalled();
    });
    it('given invalid payload should return 422 status code', async () => {
      const response = mockResponse();
      user.userId = '2';
      await controller.create(user, response);
      expect(response.json).toHaveBeenCalledTimes(1);
      expect(response.status).toHaveBeenCalledTimes(1);
      expect(response.status).toHaveBeenCalledWith(422);
      expect(service.save).not.toHaveBeenCalled();
    });
  });

  describe('update', () => {
    it('given valid payload and user exist should update a user', async () => {
      const response = mockResponse();
      user.userId = '1';
      await controller.update('1', user, response);
      expect(service.save).toHaveBeenCalled();
      expect(response.status).toHaveBeenCalledTimes(1);
      expect(response.status).toHaveBeenCalledWith(200);
    });
    it('given id does not exist should return 404 status code', async () => {
      const response = mockResponse();
      user.userId = '2';
      await controller.update('1', user, response);
      expect(response.status).toHaveBeenCalledTimes(1);
      expect(response.status).toHaveBeenCalledWith(404);
      expect(service.save).not.toHaveBeenCalled();
    });
  });
  describe('remove', () => {
    it('given valid payload and user exist should update a user', async () => {
      const response = mockResponse();
      user.userId = '1';
      await controller.update('1', user, response);
      expect(service.save).toHaveBeenCalled();
      expect(response.status).toHaveBeenCalledTimes(1);
      expect(response.status).toHaveBeenCalledWith(200);
    });
    it('given id does not exist should return 404 status code', async () => {
      const response = mockResponse();
      user.userId = '2';
      await controller.update('1', user, response);
      expect(response.status).toHaveBeenCalledTimes(1);
      expect(response.status).toHaveBeenCalledWith(404);
      expect(service.save).not.toHaveBeenCalled();
    });
  });
});
