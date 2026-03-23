import { ApiOperation } from '@nestjs/swagger';
import { Roles } from '../constants/enum';
import { OperationObject } from '@nestjs/swagger/dist/interfaces/open-api-spec.interface';
import { applyDecorators, SetMetadata } from '@nestjs/common';
import { ROLE_KEY } from './roles.guard';

const Role = (...roles: Roles[]) => SetMetadata(ROLE_KEY, roles);

// Helper function to get string representation of roles
const getRolesString = (roles: Roles[] | Roles | undefined): string => {
  if (!roles) return '';
  const rolesArray = Array.isArray(roles) ? roles : [roles];
  if (rolesArray.length === 0) return '';
  return rolesArray.map(role => `[${role.toUpperCase()}]`).join(' ') + ' '; // Add a space after the roles string
};

/**
 * A custom decorator that enhances Swagger's @ApiOperation with role-based prefixes.
 * It prepends stringified roles (e.g., "[ADMIN] [USER]") to the operation summary.
 * 
 * @param options - The standard ApiOperation options plus an optional `roles` field.
 *                  `roles` can be a single Role or an array of Roles.
 */
export const ApiOperationWithRoles = (
  options: Omit<OperationObject, 'summary'> & { summary?: string; roles?: Roles[] | Roles },
): MethodDecorator => {
  return (target: any, propertyKey: string | symbol, descriptor: PropertyDescriptor) => {
    const { roles, summary, ...restOfOptions } = options;

    const rolesPrefix = getRolesString(roles);
    // Ensure summary is treated as an empty string if undefined
    const currentSummary = summary || '';
    const newSummary = `${rolesPrefix}${currentSummary}`.trim();

    // Apply the original ApiOperation decorator with the new summary
    ApiOperation({ ...restOfOptions, summary: newSummary })(target, propertyKey, descriptor);
  };
};

/**
 * Combines Role and ApiOperationWithRoles decorators for convenience.
 * This single decorator will apply both role metadata for the guard and update Swagger summary.
 * 
 * @param roles - The roles required for this endpoint.
 * @param apiOperationOptions - The Swagger operation options (summary, description, etc.).
 */
export const ProtectedOperation = (
  roles: Roles[] | Roles, // Changed to accept single role or array
  apiOperationOptions: Omit<OperationObject, 'summary'> & { summary?: string },
) => {
  const rolesArray = Array.isArray(roles) ? roles : [roles]; // Ensure it's an array for Role decorator
  return applyDecorators(
    Role(...rolesArray), // Apply the Role decorator for access control
    ApiOperationWithRoles({ ...apiOperationOptions, roles: rolesArray }) // Apply ApiOperationWithRoles for Swagger docs
  );
};
