DROP TABLE IF EXISTS public.cs_ocean_contract_amendment;
CREATE TABLE public.cs_ocean_contract_amendment (
    ocean_contract_group_id integer NOT NULL,
    ocean_contract_amendment_id integer NOT NULL,
    amendment_name character varying(100) NOT NULL,
    amendment_status numeric(1,0) NOT NULL,
    administrator character varying(30) NOT NULL,
    date_added timestamp with time zone NOT NULL,
    amendment_notes text,
    base_rate_eff_date date,
    surcharge_eff_date date,
    gri_eff_date date,
    received_date timestamp with time zone,
    amendement_type character varying(2),
    auditor_assigned integer,
    rate_admin_id integer,
    last_modified timestamp without time zone,
    auditor_name character varying,
    external_ref_id text,
    share_amendment_status integer,
    approved_by text,
    customer_name text,
    is_esuds boolean
);

ALTER TABLE ONLY public.cs_ocean_contract_amendment ADD CONSTRAINT pk_cs_ocean_contract_amendment PRIMARY KEY (ocean_contract_amendment_id);

INSERT INTO public.cs_ocean_contract_amendment (ocean_contract_group_id, ocean_contract_amendment_id, amendment_name, amendment_status, administrator, date_added, amendment_notes, base_rate_eff_date, surcharge_eff_date, gri_eff_date, received_date, amendement_type, auditor_assigned, rate_admin_id, last_modified, auditor_name, external_ref_id, share_amendment_status, approved_by, customer_name, is_esuds) VALUES (92477, 464853, 'Initial Load', 2, 'Meg Heier', '2021-12-01 20:42:07.027814+00', NULL, NULL, NULL, NULL, '2021-12-01 19:36:00+00', 'AM', NULL, 313731, '2021-12-01 15:42:41.120895', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.cs_ocean_contract_amendment (ocean_contract_group_id, ocean_contract_amendment_id, amendment_name, amendment_status, administrator, date_added, amendment_notes, base_rate_eff_date, surcharge_eff_date, gri_eff_date, received_date, amendement_type, auditor_assigned, rate_admin_id, last_modified, auditor_name, external_ref_id, share_amendment_status, approved_by, customer_name, is_esuds) VALUES (63709, 464852, 'AMD 0014', 2, 'Jeremy Alejandrino', '2021-12-01 19:47:32.123813+00', NULL, NULL, NULL, NULL, '2021-12-02 08:43:00+00', 'AM', NULL, 217305, '2021-12-01 15:05:39.631954', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.cs_ocean_contract_amendment (ocean_contract_group_id, ocean_contract_amendment_id, amendment_name, amendment_status, administrator, date_added, amendment_notes, base_rate_eff_date, surcharge_eff_date, gri_eff_date, received_date, amendement_type, auditor_assigned, rate_admin_id, last_modified, auditor_name, external_ref_id, share_amendment_status, approved_by, customer_name, is_esuds) VALUES (90077, 464851, '8', 2, 'Shawn Cheung', '2021-12-01 19:41:12.741908+00', NULL, NULL, NULL, NULL, '2021-12-01 16:40:00+00', 'AM', NULL, 293908, '2021-12-01 14:42:02.093108', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.cs_ocean_contract_amendment (ocean_contract_group_id, ocean_contract_amendment_id, amendment_name, amendment_status, administrator, date_added, amendment_notes, base_rate_eff_date, surcharge_eff_date, gri_eff_date, received_date, amendement_type, auditor_assigned, rate_admin_id, last_modified, auditor_name, external_ref_id, share_amendment_status, approved_by, customer_name, is_esuds) VALUES (21348, 464850, '12-01-2021 Unique Logistics', 2, 'Kamal Ahmad', '2021-12-01 19:39:50.226278+00', NULL, NULL, NULL, NULL, '2021-12-01 19:37:00+00', 'AM', NULL, 318546, '2021-12-01 14:39:52.450972', NULL, NULL, NULL, NULL, NULL, NULL);

