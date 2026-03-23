import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { JwtPayloadDto } from '../dtos/jwt-payload.dto';
import { Roles, ServiceType } from '../constants/enum';
import { SetMetadata } from '@nestjs/common';
import { Observable } from 'rxjs';

export const ROLE_KEY = 'role';
export const SERVICE_TYPE_KEY = 'serviceType';

export const Role = (...role: Roles[]) => SetMetadata(ROLE_KEY, role);
export const ServiceTypeGuard = (...serviceTypes: ServiceType[]) => SetMetadata(SERVICE_TYPE_KEY, serviceTypes);

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean | Promise<boolean> | Observable<boolean> {
    const requiredRoles = this.reflector.get<Roles[]>(ROLE_KEY, context.getHandler()) || [];
    const requiredServiceTypes = this.reflector.get<ServiceType[]>(SERVICE_TYPE_KEY, context.getHandler()) || [];

    const request = context.switchToHttp().getRequest();
    const user: JwtPayloadDto = request.user;

    const hasRole = requiredRoles.length === 0 || requiredRoles.includes(user.role);
    const hasServiceType = requiredServiceTypes.length === 0 || requiredServiceTypes.includes(user.serviceType);

    if (!hasRole || !hasServiceType) {
      throw new ForbiddenException('Access denied due to insufficient role or service type');
    }

    return true; 
  }
}
