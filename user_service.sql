DROP TABLE IF EXISTS public.tenants;
CREATE TABLE public.tenants
(
    id serial PRIMARY KEY,
    tenant_name varchar(255) NOT NULL,
    created_at timestamp,
    updated_at timestamp,
    is_active boolean NOT NULL,
    is_deleted boolean NOT NULL
);


CREATE UNIQUE INDEX tenants_name_uindex ON public.tenants (tenant_name);

DROP TABLE IF EXISTS public.subscriptions;
CREATE TABLE public.subscriptions
(
    id serial PRIMARY KEY,
    tenant_id integer NOT NULL,
    first_name varchar(255),
    last_name varchar(255),
    email varchar(255),
    password varchar(255),
    created_at timestamp,
    updated_at timestamp,
    is_active boolean NOT NULL,
    is_deleted boolean NOT NULL
);

CREATE UNIQUE INDEX subscriptions_username_uindex ON public.subscriptions (email);

DROP TABLE IF EXISTS public.role_permissions;
CREATE TABLE public.role_permissions
(
    id serial PRIMARY KEY,
    role_name varchar(255) NOT NULL,
    role_permissions json NOT NULL,
    created_at timestamp,
    updated_at timestamp,
    is_deleted boolean NOT NULL
);

CREATE UNIQUE INDEX role_permissions_role_name_uindex ON public.role_permissions (role_name);

DROP TABLE IF EXISTS public.subscription_roles;
CREATE TABLE public.subscription_roles
(
    id serial PRIMARY KEY,
    subscription_id integer NOT NULL,
    role_permissions_id integer NOT NULL,
    permission_extention json DEFAULT '[]',
    created_at timestamp,
    updated_at timestamp,
    is_deleted boolean NOT NULL
);

CREATE UNIQUE INDEX subscription_roles_subscription_id_role_permissions_id_uindex ON public.subscription_roles (subscription_id, role_permissions_id);

DROP TABLE IF EXISTS public.subscription_roles_temp;
CREATE TABLE public.subscription_roles_temp
(
    id serial PRIMARY KEY,
    subscription_id integer NOT NULL,
    role_permissions_id integer NOT NULL,
    permission_extention json DEFAULT '[]',
    created_at timestamp,
    updated_at timestamp,
    is_deleted boolean NOT NULL
);

