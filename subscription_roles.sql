INSERT INTO public.subscription_roles
SELECT *
FROM public.subscription_roles_temp
ON CONFLICT DO NOTHING;

DROP TABLE public.subscription_roles_temp;
