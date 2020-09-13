SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--		
 -- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -		
 --		

  CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;		

 
  --		
 -- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -		
 --		

  COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';		


--
-- Name: intarray; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS intarray WITH SCHEMA public;


--
-- Name: EXTENSION intarray; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION intarray IS 'functions, operators, and index support for 1-D arrays of integers';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_admin_comments (
    id integer NOT NULL,
    resource_id character varying(255) NOT NULL,
    resource_type character varying(255) NOT NULL,
    author_id integer,
    author_type character varying(255),
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    namespace character varying(255)
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_admin_comments_id_seq OWNED BY public.active_admin_comments.id;


--
-- Name: ambassadors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ambassadors (
    id bigint NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    company character varying NOT NULL,
    title character varying NOT NULL,
    location character varying NOT NULL,
    year integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    avatar character varying
);


--
-- Name: ambassadors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ambassadors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ambassadors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ambassadors_id_seq OWNED BY public.ambassadors.id;


--
-- Name: annual_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.annual_schedules (
    id bigint NOT NULL,
    year integer,
    dates jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: annual_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.annual_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: annual_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.annual_schedules_id_seq OWNED BY public.annual_schedules.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.articles (
    id bigint NOT NULL,
    title text NOT NULL,
    body text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    header_image character varying,
    company_id bigint,
    submission_id bigint,
    submitter_id bigint,
    video_url character varying
);


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.articles_id_seq OWNED BY public.articles.id;


--
-- Name: articles_tracks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.articles_tracks (
    article_id bigint NOT NULL,
    track_id bigint NOT NULL
);


--
-- Name: attendee_goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attendee_goals (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attendee_goals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attendee_goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attendee_goals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attendee_goals_id_seq OWNED BY public.attendee_goals.id;


--
-- Name: attendee_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attendee_messages (
    id bigint NOT NULL,
    subject character varying NOT NULL,
    body text NOT NULL,
    submission_id bigint NOT NULL,
    sent_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: attendee_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attendee_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attendee_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attendee_messages_id_seq OWNED BY public.attendee_messages.id;


--
-- Name: authorships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authorships (
    id bigint NOT NULL,
    article_id bigint,
    user_id bigint,
    is_displayed boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: authorships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.authorships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authorships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.authorships_id_seq OWNED BY public.authorships.id;


--
-- Name: cfp_extensions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cfp_extensions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    expires_at date NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: cfp_extensions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cfp_extensions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cfp_extensions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cfp_extensions_id_seq OWNED BY public.cfp_extensions.id;


--
-- Name: clusters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clusters (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    header_image character varying,
    slug character varying
);


--
-- Name: clusters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clusters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clusters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clusters_id_seq OWNED BY public.clusters.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    user_id integer,
    submission_id integer,
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: companies_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies_users (
    id bigint NOT NULL,
    company_id bigint,
    user_id bigint
);


--
-- Name: companies_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.companies_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.companies_users_id_seq OWNED BY public.companies_users.id;


--
-- Name: ethnicities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ethnicities (
    id bigint NOT NULL,
    name character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ethnicities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ethnicities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ethnicities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ethnicities_id_seq OWNED BY public.ethnicities.id;


--
-- Name: feedback; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feedback (
    id bigint NOT NULL,
    rating integer,
    comments text,
    submission_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id bigint
);


--
-- Name: feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feedback_id_seq OWNED BY public.feedback.id;


--
-- Name: general_inquiries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.general_inquiries (
    id integer NOT NULL,
    contact_name character varying(255),
    contact_email character varying(255),
    interest text,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    company character varying
);


--
-- Name: general_inquiries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.general_inquiries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: general_inquiries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.general_inquiries_id_seq OWNED BY public.general_inquiries.id;


--
-- Name: homepage_ctas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.homepage_ctas (
    id integer NOT NULL,
    title character varying NOT NULL,
    subtitle character varying NOT NULL,
    body character varying NOT NULL,
    link_text character varying NOT NULL,
    link_href character varying NOT NULL,
    relevant_to_cycle character varying,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    track_id bigint
);


--
-- Name: homepage_ctas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.homepage_ctas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: homepage_ctas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.homepage_ctas_id_seq OWNED BY public.homepage_ctas.id;


--
-- Name: industry_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industry_types (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: industry_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.industry_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industry_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.industry_types_id_seq OWNED BY public.industry_types.id;


--
-- Name: job_fair_signup_time_slots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_fair_signup_time_slots (
    id bigint NOT NULL,
    job_fair_signup_id bigint NOT NULL,
    submission_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: job_fair_signup_time_slots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_fair_signup_time_slots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_fair_signup_time_slots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_fair_signup_time_slots_id_seq OWNED BY public.job_fair_signup_time_slots.id;


--
-- Name: job_fair_signups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_fair_signups (
    id bigint NOT NULL,
    company_id bigint NOT NULL,
    user_id bigint NOT NULL,
    actively_hiring boolean DEFAULT true NOT NULL,
    number_open_positions integer,
    number_hiring_next_12_months integer,
    industry_category text,
    organization_size text,
    covid_impact text,
    contact_email text,
    notes text,
    year integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    state text DEFAULT 'created'::text NOT NULL
);


--
-- Name: job_fair_signups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_fair_signups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_fair_signups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_fair_signups_id_seq OWNED BY public.job_fair_signups.id;


--
-- Name: newsletter_signups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.newsletter_signups (
    id integer NOT NULL,
    email character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: newsletter_signups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.newsletter_signups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: newsletter_signups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.newsletter_signups_id_seq OWNED BY public.newsletter_signups.id;


--
-- Name: newsroom_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.newsroom_items (
    id bigint NOT NULL,
    title character varying NOT NULL,
    attachment character varying,
    external_link character varying,
    is_active boolean DEFAULT true NOT NULL,
    release_date date NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: newsroom_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.newsroom_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: newsroom_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.newsroom_items_id_seq OWNED BY public.newsroom_items.id;


--
-- Name: oauth_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_services (
    id bigint NOT NULL,
    uid character varying NOT NULL,
    description text,
    provider character varying NOT NULL,
    user_id bigint,
    token character varying,
    refresh_token character varying,
    token_expires_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: oauth_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_services_id_seq OWNED BY public.oauth_services.id;


--
-- Name: pitch_contest_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pitch_contest_entries (
    id bigint NOT NULL,
    video_url character varying,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    year integer,
    is_active boolean DEFAULT true NOT NULL
);


--
-- Name: pitch_contest_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pitch_contest_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pitch_contest_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pitch_contest_entries_id_seq OWNED BY public.pitch_contest_entries.id;


--
-- Name: pitch_contest_votes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pitch_contest_votes (
    id bigint NOT NULL,
    user_id bigint,
    pitch_contest_entry_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pitch_contest_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pitch_contest_votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pitch_contest_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pitch_contest_votes_id_seq OWNED BY public.pitch_contest_votes.id;


--
-- Name: presenterships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.presenterships (
    id bigint NOT NULL,
    submission_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: presenterships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.presenterships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: presenterships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.presenterships_id_seq OWNED BY public.presenterships.id;


--
-- Name: publishings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publishings (
    id bigint NOT NULL,
    subject_type character varying NOT NULL,
    subject_id bigint NOT NULL,
    effective_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    featured_on_homepage boolean DEFAULT false NOT NULL,
    pinned_to_track boolean DEFAULT false NOT NULL
);


--
-- Name: publishings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.publishings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publishings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.publishings_id_seq OWNED BY public.publishings.id;


--
-- Name: registration_attendee_goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.registration_attendee_goals (
    id bigint NOT NULL,
    registration_id bigint NOT NULL,
    attendee_goal_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: registration_attendee_goals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.registration_attendee_goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: registration_attendee_goals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.registration_attendee_goals_id_seq OWNED BY public.registration_attendee_goals.id;


--
-- Name: registration_ethnicities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.registration_ethnicities (
    id bigint NOT NULL,
    registration_id bigint,
    ethnicity_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: registration_ethnicities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.registration_ethnicities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: registration_ethnicities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.registration_ethnicities_id_seq OWNED BY public.registration_ethnicities.id;


--
-- Name: registrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.registrations (
    id integer NOT NULL,
    user_id integer,
    year integer,
    contact_email character varying(255),
    zip character varying(255),
    original_company_name character varying(255),
    gender character varying(255),
    primary_role character varying(255),
    track_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    calendar_token character varying(255),
    age_range character varying,
    learn_more_pledge_1p boolean DEFAULT false NOT NULL,
    company_id bigint,
    coc_acknowledgement boolean DEFAULT false NOT NULL
);


--
-- Name: registrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.registrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.registrations_id_seq OWNED BY public.registrations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sent_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sent_notifications (
    id integer NOT NULL,
    kind character varying NOT NULL,
    recipient_email character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    subject_type character varying NOT NULL,
    subject_id bigint NOT NULL
);


--
-- Name: sent_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sent_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sent_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sent_notifications_id_seq OWNED BY public.sent_notifications.id;


--
-- Name: session_registrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session_registrations (
    id integer NOT NULL,
    registration_id integer,
    submission_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: session_registrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.session_registrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: session_registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.session_registrations_id_seq OWNED BY public.session_registrations.id;


--
-- Name: sponsor_signups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sponsor_signups (
    id integer NOT NULL,
    contact_name character varying(255),
    contact_email character varying(255),
    company character varying(255),
    interest text,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sponsor_signups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sponsor_signups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sponsor_signups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sponsor_signups_id_seq OWNED BY public.sponsor_signups.id;


--
-- Name: sponsorships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sponsorships (
    id bigint NOT NULL,
    name character varying NOT NULL,
    logo character varying,
    link_href character varying NOT NULL,
    description text,
    year integer NOT NULL,
    level character varying NOT NULL,
    track_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    submission_id bigint
);


--
-- Name: sponsorships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sponsorships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sponsorships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sponsorships_id_seq OWNED BY public.sponsorships.id;


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submissions (
    id integer NOT NULL,
    submitter_id integer,
    track_id integer,
    format character varying(255),
    location character varying(255),
    time_range character varying(255),
    title text,
    description text,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    contact_email character varying(255),
    estimated_size character varying(255),
    is_confirmed boolean DEFAULT false NOT NULL,
    is_public boolean DEFAULT true NOT NULL,
    venue_id integer,
    volunteers_needed integer,
    budget_needed integer,
    start_hour double precision DEFAULT 0 NOT NULL,
    end_hour double precision DEFAULT 0 NOT NULL,
    year integer,
    state character varying(255),
    start_day integer,
    end_day integer,
    internal_notes text,
    slides_url character varying,
    video_url character varying,
    cluster_id integer,
    original_company_name character varying,
    proposed_updates json,
    open_to_collaborators boolean,
    from_underrepresented_group boolean,
    target_audience_description text,
    cached_similar_item_ids integer[] DEFAULT '{}'::integer[],
    live_stream_url character varying,
    company_id bigint,
    coc_acknowledgement boolean DEFAULT false NOT NULL,
    pitch_qualifying boolean DEFAULT false NOT NULL,
    registrant_count integer DEFAULT 0 NOT NULL,
    header_image character varying,
    has_childcare boolean DEFAULT false NOT NULL,
    noindex boolean DEFAULT false NOT NULL,
    dei_acknowledgement boolean DEFAULT false NOT NULL,
    proposal_video_url character varying,
    preferred_length character varying,
    is_virtual boolean DEFAULT false NOT NULL,
    virtual_meeting_type character varying,
    broadcast_on_youtube_live boolean DEFAULT false NOT NULL,
    zoom_oauth_service_id bigint,
    virtual_join_url text,
    is_virtual_job_fair_slot boolean DEFAULT false NOT NULL
);


--
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.submissions_id_seq OWNED BY public.submissions.id;


--
-- Name: support_areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.support_areas (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: support_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.support_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: support_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.support_areas_id_seq OWNED BY public.support_areas.id;


--
-- Name: tracks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tracks (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    icon character varying(255),
    email_alias character varying(255),
    display_order integer DEFAULT 0 NOT NULL,
    is_submittable boolean DEFAULT false NOT NULL,
    description text,
    color character varying,
    is_voteable boolean DEFAULT true NOT NULL,
    video_url character varying,
    header_image character varying,
    has_detail_page boolean DEFAULT true NOT NULL,
    video_required_for_submission boolean DEFAULT false NOT NULL
);


--
-- Name: tracks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tracks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tracks_id_seq OWNED BY public.tracks.id;


--
-- Name: tracks_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tracks_users (
    track_id integer,
    user_id integer
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    uid character varying(255),
    name character varying(255),
    email character varying(255),
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    provider character varying(255),
    team_position character varying,
    avatar character varying,
    team_priority integer,
    linkedin_url character varying,
    show_attendance_publicly boolean DEFAULT true NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: venue_adminships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.venue_adminships (
    id bigint NOT NULL,
    venue_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: venue_adminships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.venue_adminships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: venue_adminships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.venue_adminships_id_seq OWNED BY public.venue_adminships.id;


--
-- Name: venue_availabilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.venue_availabilities (
    id bigint NOT NULL,
    venue_id bigint,
    submission_id bigint,
    year integer,
    day integer,
    time_block integer
);


--
-- Name: venue_availabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.venue_availabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: venue_availabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.venue_availabilities_id_seq OWNED BY public.venue_availabilities.id;


--
-- Name: venues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.venues (
    id integer NOT NULL,
    name character varying(255),
    description text,
    contact_name character varying(255),
    contact_email character varying(255),
    contact_phone character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    address character varying(255),
    city character varying(255),
    state character varying(255),
    suite_or_unit character varying,
    seated_capacity integer DEFAULT 0,
    extra_directions text,
    company_id integer,
    standing_capacity integer DEFAULT 0,
    av_capabilities character varying,
    availability_preference character varying
);


--
-- Name: venues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.venues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: venues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.venues_id_seq OWNED BY public.venues.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id integer NOT NULL,
    item_type character varying(255) NOT NULL,
    item_id integer NOT NULL,
    event character varying(255) NOT NULL,
    whodunnit character varying(255),
    object text,
    created_at timestamp without time zone
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: volunteer_shifts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.volunteer_shifts (
    id integer NOT NULL,
    name character varying,
    day integer,
    start_hour double precision,
    end_hour double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    year integer,
    venue_id bigint
);


--
-- Name: volunteer_shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.volunteer_shifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: volunteer_shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.volunteer_shifts_id_seq OWNED BY public.volunteer_shifts.id;


--
-- Name: volunteership_shifts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.volunteership_shifts (
    id bigint NOT NULL,
    volunteership_id bigint,
    volunteer_shift_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: volunteership_shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.volunteership_shifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: volunteership_shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.volunteership_shifts_id_seq OWNED BY public.volunteership_shifts.id;


--
-- Name: volunteerships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.volunteerships (
    id integer NOT NULL,
    mobile_phone_number character varying,
    affiliated_organization character varying,
    user_id integer,
    year integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: volunteerships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.volunteerships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: volunteerships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.volunteerships_id_seq OWNED BY public.volunteerships.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.votes (
    id integer NOT NULL,
    user_id integer,
    submission_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.votes_id_seq OWNED BY public.votes.id;


--
-- Name: youtube_live_streams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.youtube_live_streams (
    id bigint NOT NULL,
    submission_id bigint NOT NULL,
    live_stream_id character varying,
    broadcast_id character varying,
    ingestion_address text,
    backup_ingestion_address text,
    rtmps_ingestion_address text,
    rtmps_backup_ingestion_address text,
    stream_name text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    kind character varying NOT NULL
);


--
-- Name: youtube_live_streams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.youtube_live_streams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: youtube_live_streams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.youtube_live_streams_id_seq OWNED BY public.youtube_live_streams.id;


--
-- Name: zip_decoding; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.zip_decoding (
    zip character varying,
    city character varying,
    state character varying,
    lat numeric,
    long numeric
);


--
-- Name: zoom_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.zoom_events (
    id bigint NOT NULL,
    submission_id bigint,
    zoom_id character varying NOT NULL,
    event_type character varying NOT NULL,
    kind character varying NOT NULL,
    host_url text,
    join_url text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    oauth_service_id bigint NOT NULL
);


--
-- Name: zoom_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.zoom_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: zoom_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.zoom_events_id_seq OWNED BY public.zoom_events.id;


--
-- Name: zoom_join_urls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.zoom_join_urls (
    id bigint NOT NULL,
    zoom_event_id bigint NOT NULL,
    user_id bigint NOT NULL,
    url text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: zoom_join_urls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.zoom_join_urls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: zoom_join_urls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.zoom_join_urls_id_seq OWNED BY public.zoom_join_urls.id;


--
-- Name: active_admin_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments ALTER COLUMN id SET DEFAULT nextval('public.active_admin_comments_id_seq'::regclass);


--
-- Name: ambassadors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ambassadors ALTER COLUMN id SET DEFAULT nextval('public.ambassadors_id_seq'::regclass);


--
-- Name: annual_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.annual_schedules ALTER COLUMN id SET DEFAULT nextval('public.annual_schedules_id_seq'::regclass);


--
-- Name: articles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles ALTER COLUMN id SET DEFAULT nextval('public.articles_id_seq'::regclass);


--
-- Name: attendee_goals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendee_goals ALTER COLUMN id SET DEFAULT nextval('public.attendee_goals_id_seq'::regclass);


--
-- Name: attendee_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendee_messages ALTER COLUMN id SET DEFAULT nextval('public.attendee_messages_id_seq'::regclass);


--
-- Name: authorships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authorships ALTER COLUMN id SET DEFAULT nextval('public.authorships_id_seq'::regclass);


--
-- Name: cfp_extensions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cfp_extensions ALTER COLUMN id SET DEFAULT nextval('public.cfp_extensions_id_seq'::regclass);


--
-- Name: clusters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters ALTER COLUMN id SET DEFAULT nextval('public.clusters_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: companies_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies_users ALTER COLUMN id SET DEFAULT nextval('public.companies_users_id_seq'::regclass);


--
-- Name: ethnicities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ethnicities ALTER COLUMN id SET DEFAULT nextval('public.ethnicities_id_seq'::regclass);


--
-- Name: feedback id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback ALTER COLUMN id SET DEFAULT nextval('public.feedback_id_seq'::regclass);


--
-- Name: general_inquiries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.general_inquiries ALTER COLUMN id SET DEFAULT nextval('public.general_inquiries_id_seq'::regclass);


--
-- Name: homepage_ctas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.homepage_ctas ALTER COLUMN id SET DEFAULT nextval('public.homepage_ctas_id_seq'::regclass);


--
-- Name: industry_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industry_types ALTER COLUMN id SET DEFAULT nextval('public.industry_types_id_seq'::regclass);


--
-- Name: job_fair_signup_time_slots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_fair_signup_time_slots ALTER COLUMN id SET DEFAULT nextval('public.job_fair_signup_time_slots_id_seq'::regclass);


--
-- Name: job_fair_signups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_fair_signups ALTER COLUMN id SET DEFAULT nextval('public.job_fair_signups_id_seq'::regclass);


--
-- Name: newsletter_signups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.newsletter_signups ALTER COLUMN id SET DEFAULT nextval('public.newsletter_signups_id_seq'::regclass);


--
-- Name: newsroom_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.newsroom_items ALTER COLUMN id SET DEFAULT nextval('public.newsroom_items_id_seq'::regclass);


--
-- Name: oauth_services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_services ALTER COLUMN id SET DEFAULT nextval('public.oauth_services_id_seq'::regclass);


--
-- Name: pitch_contest_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pitch_contest_entries ALTER COLUMN id SET DEFAULT nextval('public.pitch_contest_entries_id_seq'::regclass);


--
-- Name: pitch_contest_votes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pitch_contest_votes ALTER COLUMN id SET DEFAULT nextval('public.pitch_contest_votes_id_seq'::regclass);


--
-- Name: presenterships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.presenterships ALTER COLUMN id SET DEFAULT nextval('public.presenterships_id_seq'::regclass);


--
-- Name: publishings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publishings ALTER COLUMN id SET DEFAULT nextval('public.publishings_id_seq'::regclass);


--
-- Name: registration_attendee_goals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_attendee_goals ALTER COLUMN id SET DEFAULT nextval('public.registration_attendee_goals_id_seq'::regclass);


--
-- Name: registration_ethnicities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_ethnicities ALTER COLUMN id SET DEFAULT nextval('public.registration_ethnicities_id_seq'::regclass);


--
-- Name: registrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registrations ALTER COLUMN id SET DEFAULT nextval('public.registrations_id_seq'::regclass);


--
-- Name: sent_notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sent_notifications ALTER COLUMN id SET DEFAULT nextval('public.sent_notifications_id_seq'::regclass);


--
-- Name: session_registrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_registrations ALTER COLUMN id SET DEFAULT nextval('public.session_registrations_id_seq'::regclass);


--
-- Name: sponsor_signups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sponsor_signups ALTER COLUMN id SET DEFAULT nextval('public.sponsor_signups_id_seq'::regclass);


--
-- Name: sponsorships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sponsorships ALTER COLUMN id SET DEFAULT nextval('public.sponsorships_id_seq'::regclass);


--
-- Name: submissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions ALTER COLUMN id SET DEFAULT nextval('public.submissions_id_seq'::regclass);


--
-- Name: support_areas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_areas ALTER COLUMN id SET DEFAULT nextval('public.support_areas_id_seq'::regclass);


--
-- Name: tracks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tracks ALTER COLUMN id SET DEFAULT nextval('public.tracks_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: venue_adminships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue_adminships ALTER COLUMN id SET DEFAULT nextval('public.venue_adminships_id_seq'::regclass);


--
-- Name: venue_availabilities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue_availabilities ALTER COLUMN id SET DEFAULT nextval('public.venue_availabilities_id_seq'::regclass);


--
-- Name: venues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venues ALTER COLUMN id SET DEFAULT nextval('public.venues_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: volunteer_shifts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volunteer_shifts ALTER COLUMN id SET DEFAULT nextval('public.volunteer_shifts_id_seq'::regclass);


--
-- Name: volunteership_shifts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volunteership_shifts ALTER COLUMN id SET DEFAULT nextval('public.volunteership_shifts_id_seq'::regclass);


--
-- Name: volunteerships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volunteerships ALTER COLUMN id SET DEFAULT nextval('public.volunteerships_id_seq'::regclass);


--
-- Name: votes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes ALTER COLUMN id SET DEFAULT nextval('public.votes_id_seq'::regclass);


--
-- Name: youtube_live_streams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.youtube_live_streams ALTER COLUMN id SET DEFAULT nextval('public.youtube_live_streams_id_seq'::regclass);


--
-- Name: zoom_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zoom_events ALTER COLUMN id SET DEFAULT nextval('public.zoom_events_id_seq'::regclass);


--
-- Name: zoom_join_urls id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zoom_join_urls ALTER COLUMN id SET DEFAULT nextval('public.zoom_join_urls_id_seq'::regclass);


--
-- Name: active_admin_comments admin_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments
    ADD CONSTRAINT admin_notes_pkey PRIMARY KEY (id);


--
-- Name: ambassadors ambassadors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ambassadors
    ADD CONSTRAINT ambassadors_pkey PRIMARY KEY (id);


--
-- Name: annual_schedules annual_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.annual_schedules
    ADD CONSTRAINT annual_schedules_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: attendee_goals attendee_goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendee_goals
    ADD CONSTRAINT attendee_goals_pkey PRIMARY KEY (id);


--
-- Name: attendee_messages attendee_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendee_messages
    ADD CONSTRAINT attendee_messages_pkey PRIMARY KEY (id);


--
-- Name: authorships authorships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authorships
    ADD CONSTRAINT authorships_pkey PRIMARY KEY (id);


--
-- Name: cfp_extensions cfp_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cfp_extensions
    ADD CONSTRAINT cfp_extensions_pkey PRIMARY KEY (id);


--
-- Name: clusters clusters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters
    ADD CONSTRAINT clusters_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: companies_users companies_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies_users
    ADD CONSTRAINT companies_users_pkey PRIMARY KEY (id);


--
-- Name: ethnicities ethnicities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ethnicities
    ADD CONSTRAINT ethnicities_pkey PRIMARY KEY (id);


--
-- Name: feedback feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (id);


--
-- Name: general_inquiries general_inquiries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.general_inquiries
    ADD CONSTRAINT general_inquiries_pkey PRIMARY KEY (id);


--
-- Name: homepage_ctas homepage_ctas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.homepage_ctas
    ADD CONSTRAINT homepage_ctas_pkey PRIMARY KEY (id);


--
-- Name: industry_types industry_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industry_types
    ADD CONSTRAINT industry_types_pkey PRIMARY KEY (id);


--
-- Name: job_fair_signups job_fair_signups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_fair_signups
    ADD CONSTRAINT job_fair_signups_pkey PRIMARY KEY (id);


--
-- Name: newsletter_signups newsletter_signups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.newsletter_signups
    ADD CONSTRAINT newsletter_signups_pkey PRIMARY KEY (id);


--
-- Name: newsroom_items newsroom_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.newsroom_items
    ADD CONSTRAINT newsroom_items_pkey PRIMARY KEY (id);


--
-- Name: oauth_services oauth_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_services
    ADD CONSTRAINT oauth_services_pkey PRIMARY KEY (id);


--
-- Name: pitch_contest_entries pitch_contest_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pitch_contest_entries
    ADD CONSTRAINT pitch_contest_entries_pkey PRIMARY KEY (id);


--
-- Name: pitch_contest_votes pitch_contest_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pitch_contest_votes
    ADD CONSTRAINT pitch_contest_votes_pkey PRIMARY KEY (id);


--
-- Name: presenterships presenterships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.presenterships
    ADD CONSTRAINT presenterships_pkey PRIMARY KEY (id);


--
-- Name: publishings publishings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publishings
    ADD CONSTRAINT publishings_pkey PRIMARY KEY (id);


--
-- Name: registration_attendee_goals registration_attendee_goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_attendee_goals
    ADD CONSTRAINT registration_attendee_goals_pkey PRIMARY KEY (id);


--
-- Name: registration_ethnicities registration_ethnicities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_ethnicities
    ADD CONSTRAINT registration_ethnicities_pkey PRIMARY KEY (id);


--
-- Name: registrations registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registrations
    ADD CONSTRAINT registrations_pkey PRIMARY KEY (id);


--
-- Name: sent_notifications sent_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sent_notifications
    ADD CONSTRAINT sent_notifications_pkey PRIMARY KEY (id);


--
-- Name: session_registrations session_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_registrations
    ADD CONSTRAINT session_registrations_pkey PRIMARY KEY (id);


--
-- Name: sponsor_signups sponsor_signups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sponsor_signups
    ADD CONSTRAINT sponsor_signups_pkey PRIMARY KEY (id);


--
-- Name: sponsorships sponsorships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sponsorships
    ADD CONSTRAINT sponsorships_pkey PRIMARY KEY (id);


--
-- Name: submissions submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (id);


--
-- Name: support_areas support_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_areas
    ADD CONSTRAINT support_areas_pkey PRIMARY KEY (id);


--
-- Name: tracks tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: venue_adminships venue_adminships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue_adminships
    ADD CONSTRAINT venue_adminships_pkey PRIMARY KEY (id);


--
-- Name: venue_availabilities venue_availabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue_availabilities
    ADD CONSTRAINT venue_availabilities_pkey PRIMARY KEY (id);


--
-- Name: venues venues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venues
    ADD CONSTRAINT venues_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: volunteer_shifts volunteer_shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volunteer_shifts
    ADD CONSTRAINT volunteer_shifts_pkey PRIMARY KEY (id);


--
-- Name: volunteership_shifts volunteership_shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volunteership_shifts
    ADD CONSTRAINT volunteership_shifts_pkey PRIMARY KEY (id);


--
-- Name: volunteerships volunteerships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volunteerships
    ADD CONSTRAINT volunteerships_pkey PRIMARY KEY (id);


--
-- Name: votes votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: youtube_live_streams youtube_live_streams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.youtube_live_streams
    ADD CONSTRAINT youtube_live_streams_pkey PRIMARY KEY (id);


--
-- Name: zoom_events zoom_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zoom_events
    ADD CONSTRAINT zoom_events_pkey PRIMARY KEY (id);


--
-- Name: zoom_join_urls zoom_join_urls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zoom_join_urls
    ADD CONSTRAINT zoom_join_urls_pkey PRIMARY KEY (id);


--
-- Name: fulltext_articles_body_english; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_articles_body_english ON public.articles USING gin (to_tsvector('english'::regconfig, body));


--
-- Name: fulltext_articles_title_english; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_articles_title_english ON public.articles USING gin (to_tsvector('english'::regconfig, title));


--
-- Name: fulltext_companies_name_english; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_companies_name_english ON public.companies USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: fulltext_submissions_description_english; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_submissions_description_english ON public.submissions USING gin (to_tsvector('english'::regconfig, description));


--
-- Name: fulltext_submissions_title_english; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_submissions_title_english ON public.submissions USING gin (to_tsvector('english'::regconfig, title));


--
-- Name: fulltext_users_name_english; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_users_name_english ON public.users USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: fulltext_venues_name_english; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_venues_name_english ON public.venues USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: idx_companies_name_contains; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_companies_name_contains ON public.companies USING gin (name public.gin_trgm_ops);


--
-- Name: idx_companies_name_contains_gist; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_companies_name_contains_gist ON public.companies USING gist (name public.gist_trgm_ops);


--
-- Name: idx_submissions_description_contains; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_submissions_description_contains ON public.submissions USING gin (description public.gin_trgm_ops);


--
-- Name: idx_submissions_description_contains_gist; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_submissions_description_contains_gist ON public.submissions USING gist (description public.gist_trgm_ops);


--
-- Name: idx_submissions_title_contains; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_submissions_title_contains ON public.submissions USING gin (title public.gin_trgm_ops);


--
-- Name: idx_submissions_title_contains_gist; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_submissions_title_contains_gist ON public.submissions USING gist (title public.gist_trgm_ops);


--
-- Name: idx_users_email_contains; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_email_contains ON public.users USING gin (email public.gin_trgm_ops);


--
-- Name: idx_users_email_contains_gist; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_email_contains_gist ON public.users USING gist (email public.gist_trgm_ops);


--
-- Name: idx_users_name_contains; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_name_contains ON public.users USING gin (name public.gin_trgm_ops);


--
-- Name: idx_users_name_contains_gist; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_name_contains_gist ON public.users USING gist (name public.gist_trgm_ops);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON public.active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_namespace ON public.active_admin_comments USING btree (namespace);


--
-- Name: index_admin_notes_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admin_notes_on_resource_type_and_resource_id ON public.active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_annual_schedules_on_year; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_annual_schedules_on_year ON public.annual_schedules USING btree (year);


--
-- Name: index_articles_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_company_id ON public.articles USING btree (company_id);


--
-- Name: index_articles_on_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_submission_id ON public.articles USING btree (submission_id);


--
-- Name: index_articles_on_submitter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_submitter_id ON public.articles USING btree (submitter_id);


--
-- Name: index_articles_tracks_on_article_id_and_track_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_tracks_on_article_id_and_track_id ON public.articles_tracks USING btree (article_id, track_id);


--
-- Name: index_attendee_messages_on_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attendee_messages_on_submission_id ON public.attendee_messages USING btree (submission_id);


--
-- Name: index_authorships_on_article_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_authorships_on_article_id ON public.authorships USING btree (article_id);


--
-- Name: index_authorships_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_authorships_on_user_id ON public.authorships USING btree (user_id);


--
-- Name: index_cfp_extensions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cfp_extensions_on_user_id ON public.cfp_extensions USING btree (user_id);


--
-- Name: index_comments_on_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_submission_id ON public.comments USING btree (submission_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_user_id ON public.comments USING btree (user_id);


--
-- Name: index_companies_on_lower_name_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_companies_on_lower_name_unique ON public.companies USING btree (lower((name)::text) varchar_pattern_ops);


--
-- Name: index_companies_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_companies_on_name ON public.companies USING btree (name);


--
-- Name: index_companies_users_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_users_on_company_id ON public.companies_users USING btree (company_id);


--
-- Name: index_companies_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_users_on_user_id ON public.companies_users USING btree (user_id);


--
-- Name: index_feedback_on_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_feedback_on_submission_id ON public.feedback USING btree (submission_id);


--
-- Name: index_feedback_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_feedback_on_user_id ON public.feedback USING btree (user_id);


--
-- Name: index_homepage_ctas_on_track_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_homepage_ctas_on_track_id ON public.homepage_ctas USING btree (track_id);


--
-- Name: index_job_fair_signup_time_slots_on_job_fair_signup_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_fair_signup_time_slots_on_job_fair_signup_id ON public.job_fair_signup_time_slots USING btree (job_fair_signup_id);


--
-- Name: index_job_fair_signup_time_slots_on_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_fair_signup_time_slots_on_submission_id ON public.job_fair_signup_time_slots USING btree (submission_id);


--
-- Name: index_job_fair_signups_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_fair_signups_on_company_id ON public.job_fair_signups USING btree (company_id);


--
-- Name: index_job_fair_signups_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_fair_signups_on_user_id ON public.job_fair_signups USING btree (user_id);


--
-- Name: index_oauth_services_on_provider_and_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_services_on_provider_and_uid ON public.oauth_services USING btree (provider, uid);


--
-- Name: index_oauth_services_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_services_on_user_id ON public.oauth_services USING btree (user_id);


--
-- Name: index_pitch_contest_votes_on_pitch_contest_entry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pitch_contest_votes_on_pitch_contest_entry_id ON public.pitch_contest_votes USING btree (pitch_contest_entry_id);


--
-- Name: index_pitch_contest_votes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pitch_contest_votes_on_user_id ON public.pitch_contest_votes USING btree (user_id);


--
-- Name: index_presenterships_on_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_presenterships_on_submission_id ON public.presenterships USING btree (submission_id);


--
-- Name: index_presenterships_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_presenterships_on_user_id ON public.presenterships USING btree (user_id);


--
-- Name: index_publishings_on_effective_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_publishings_on_effective_at ON public.publishings USING btree (effective_at);


--
-- Name: index_publishings_on_subject_type_and_subject_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_publishings_on_subject_type_and_subject_id ON public.publishings USING btree (subject_type, subject_id);


--
-- Name: index_registration_attendee_goals_on_attendee_goal_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registration_attendee_goals_on_attendee_goal_id ON public.registration_attendee_goals USING btree (attendee_goal_id);


--
-- Name: index_registration_attendee_goals_on_registration_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registration_attendee_goals_on_registration_id ON public.registration_attendee_goals USING btree (registration_id);


--
-- Name: index_registration_ethnicities_on_ethnicity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registration_ethnicities_on_ethnicity_id ON public.registration_ethnicities USING btree (ethnicity_id);


--
-- Name: index_registration_ethnicities_on_registration_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registration_ethnicities_on_registration_id ON public.registration_ethnicities USING btree (registration_id);


--
-- Name: index_registrations_on_calendar_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_registrations_on_calendar_token ON public.registrations USING btree (calendar_token);


--
-- Name: index_registrations_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registrations_on_company_id ON public.registrations USING btree (company_id);


--
-- Name: index_registrations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registrations_on_user_id ON public.registrations USING btree (user_id);


--
-- Name: index_sent_notifications_on_subject_type_and_subject_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sent_notifications_on_subject_type_and_subject_id ON public.sent_notifications USING btree (subject_type, subject_id);


--
-- Name: index_session_registrations_on_registration_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_session_registrations_on_registration_id ON public.session_registrations USING btree (registration_id);


--
-- Name: index_session_registrations_on_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_session_registrations_on_submission_id ON public.session_registrations USING btree (submission_id);


--
-- Name: index_sponsorships_on_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sponsorships_on_submission_id ON public.sponsorships USING btree (submission_id);


--
-- Name: index_sponsorships_on_track_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sponsorships_on_track_id ON public.sponsorships USING btree (track_id);


--
-- Name: index_submissions_on_cluster_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submissions_on_cluster_id ON public.submissions USING btree (cluster_id);


--
-- Name: index_submissions_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submissions_on_company_id ON public.submissions USING btree (company_id);


--
-- Name: index_submissions_on_submitter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submissions_on_submitter_id ON public.submissions USING btree (submitter_id);


--
-- Name: index_submissions_on_track_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submissions_on_track_id ON public.submissions USING btree (track_id);


--
-- Name: index_submissions_on_zoom_oauth_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submissions_on_zoom_oauth_service_id ON public.submissions USING btree (zoom_oauth_service_id);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_venue_adminships_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_venue_adminships_on_user_id ON public.venue_adminships USING btree (user_id);


--
-- Name: index_venue_adminships_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_venue_adminships_on_venue_id ON public.venue_adminships USING btree (venue_id);


--
-- Name: index_venue_availabilities_on_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_venue_availabilities_on_submission_id ON public.venue_availabilities USING btree (submission_id);


--
-- Name: index_venue_availabilities_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_venue_availabilities_on_venue_id ON public.venue_availabilities USING btree (venue_id);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON public.versions USING btree (item_type, item_id);


--
-- Name: index_volunteer_shifts_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_volunteer_shifts_on_venue_id ON public.volunteer_shifts USING btree (venue_id);


--
-- Name: index_volunteership_shifts_on_volunteer_shift_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_volunteership_shifts_on_volunteer_shift_id ON public.volunteership_shifts USING btree (volunteer_shift_id);


--
-- Name: index_volunteership_shifts_on_volunteership_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_volunteership_shifts_on_volunteership_id ON public.volunteership_shifts USING btree (volunteership_id);


--
-- Name: index_volunteerships_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_volunteerships_on_user_id ON public.volunteerships USING btree (user_id);


--
-- Name: index_votes_on_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_submission_id ON public.votes USING btree (submission_id);


--
-- Name: index_votes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_user_id ON public.votes USING btree (user_id);


--
-- Name: index_youtube_live_streams_on_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_youtube_live_streams_on_submission_id ON public.youtube_live_streams USING btree (submission_id);


--
-- Name: index_zoom_events_on_oauth_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_zoom_events_on_oauth_service_id ON public.zoom_events USING btree (oauth_service_id);


--
-- Name: index_zoom_events_on_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_zoom_events_on_submission_id ON public.zoom_events USING btree (submission_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: registration_attendee_goals fk_rails_00326415bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_attendee_goals
    ADD CONSTRAINT fk_rails_00326415bc FOREIGN KEY (registration_id) REFERENCES public.registrations(id);


--
-- Name: venue_adminships fk_rails_033c107f44; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue_adminships
    ADD CONSTRAINT fk_rails_033c107f44 FOREIGN KEY (venue_id) REFERENCES public.venues(id);


--
-- Name: youtube_live_streams fk_rails_040054a029; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.youtube_live_streams
    ADD CONSTRAINT fk_rails_040054a029 FOREIGN KEY (submission_id) REFERENCES public.submissions(id);


--
-- Name: pitch_contest_votes fk_rails_051f1858c3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pitch_contest_votes
    ADD CONSTRAINT fk_rails_051f1858c3 FOREIGN KEY (pitch_contest_entry_id) REFERENCES public.pitch_contest_entries(id);


--
-- Name: venues fk_rails_077040617e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venues
    ADD CONSTRAINT fk_rails_077040617e FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: job_fair_signup_time_slots fk_rails_0d0be12d22; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_fair_signup_time_slots
    ADD CONSTRAINT fk_rails_0d0be12d22 FOREIGN KEY (job_fair_signup_id) REFERENCES public.job_fair_signups(id);


--
-- Name: submissions fk_rails_0ebbbc745a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT fk_rails_0ebbbc745a FOREIGN KEY (zoom_oauth_service_id) REFERENCES public.oauth_services(id);


--
-- Name: sponsorships fk_rails_10fd4596a4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sponsorships
    ADD CONSTRAINT fk_rails_10fd4596a4 FOREIGN KEY (submission_id) REFERENCES public.submissions(id);


--
-- Name: oauth_services fk_rails_1682f97daa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_services
    ADD CONSTRAINT fk_rails_1682f97daa FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: presenterships fk_rails_193171f9e9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.presenterships
    ADD CONSTRAINT fk_rails_193171f9e9 FOREIGN KEY (submission_id) REFERENCES public.submissions(id);


--
-- Name: registration_ethnicities fk_rails_1e411f9fdf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_ethnicities
    ADD CONSTRAINT fk_rails_1e411f9fdf FOREIGN KEY (ethnicity_id) REFERENCES public.ethnicities(id);


--
-- Name: volunteerships fk_rails_26e12c935b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volunteerships
    ADD CONSTRAINT fk_rails_26e12c935b FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: registrations fk_rails_2e0658f554; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registrations
    ADD CONSTRAINT fk_rails_2e0658f554 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: feedback fk_rails_3ffcea2ae3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT fk_rails_3ffcea2ae3 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: authorships fk_rails_414ad6261a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authorships
    ADD CONSTRAINT fk_rails_414ad6261a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: registration_ethnicities fk_rails_42dcd02c65; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_ethnicities
    ADD CONSTRAINT fk_rails_42dcd02c65 FOREIGN KEY (registration_id) REFERENCES public.registrations(id);


--
-- Name: cfp_extensions fk_rails_4475ebeea9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cfp_extensions
    ADD CONSTRAINT fk_rails_4475ebeea9 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: pitch_contest_votes fk_rails_4daa05456f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pitch_contest_votes
    ADD CONSTRAINT fk_rails_4daa05456f FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: registrations fk_rails_4dafc7e520; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registrations
    ADD CONSTRAINT fk_rails_4dafc7e520 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: volunteership_shifts fk_rails_4deb72ee78; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volunteership_shifts
    ADD CONSTRAINT fk_rails_4deb72ee78 FOREIGN KEY (volunteership_id) REFERENCES public.volunteerships(id);


--
-- Name: zoom_events fk_rails_5125a0330a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zoom_events
    ADD CONSTRAINT fk_rails_5125a0330a FOREIGN KEY (submission_id) REFERENCES public.submissions(id);


--
-- Name: attendee_messages fk_rails_555266c0e1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendee_messages
    ADD CONSTRAINT fk_rails_555266c0e1 FOREIGN KEY (submission_id) REFERENCES public.submissions(id);


--
-- Name: job_fair_signup_time_slots fk_rails_6ec4e8f2ea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_fair_signup_time_slots
    ADD CONSTRAINT fk_rails_6ec4e8f2ea FOREIGN KEY (submission_id) REFERENCES public.submissions(id);


--
-- Name: registration_attendee_goals fk_rails_7145612043; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_attendee_goals
    ADD CONSTRAINT fk_rails_7145612043 FOREIGN KEY (attendee_goal_id) REFERENCES public.attendee_goals(id);


--
-- Name: feedback fk_rails_7c9bf47fa8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT fk_rails_7c9bf47fa8 FOREIGN KEY (submission_id) REFERENCES public.submissions(id);


--
-- Name: volunteership_shifts fk_rails_8ff1f98788; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volunteership_shifts
    ADD CONSTRAINT fk_rails_8ff1f98788 FOREIGN KEY (volunteer_shift_id) REFERENCES public.volunteer_shifts(id);


--
-- Name: articles fk_rails_9ae110b456; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT fk_rails_9ae110b456 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: volunteer_shifts fk_rails_9c4ffa0245; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volunteer_shifts
    ADD CONSTRAINT fk_rails_9c4ffa0245 FOREIGN KEY (venue_id) REFERENCES public.venues(id);


--
-- Name: articles_tracks fk_rails_a51247846b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles_tracks
    ADD CONSTRAINT fk_rails_a51247846b FOREIGN KEY (track_id) REFERENCES public.tracks(id);


--
-- Name: articles fk_rails_af9e6e0455; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT fk_rails_af9e6e0455 FOREIGN KEY (submitter_id) REFERENCES public.users(id);


--
-- Name: job_fair_signups fk_rails_b389018500; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_fair_signups
    ADD CONSTRAINT fk_rails_b389018500 FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: authorships fk_rails_c386d1f71d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authorships
    ADD CONSTRAINT fk_rails_c386d1f71d FOREIGN KEY (article_id) REFERENCES public.articles(id);


--
-- Name: zoom_join_urls fk_rails_c746283d97; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zoom_join_urls
    ADD CONSTRAINT fk_rails_c746283d97 FOREIGN KEY (zoom_event_id) REFERENCES public.zoom_events(id);


--
-- Name: homepage_ctas fk_rails_d6aa0aad97; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.homepage_ctas
    ADD CONSTRAINT fk_rails_d6aa0aad97 FOREIGN KEY (track_id) REFERENCES public.tracks(id);


--
-- Name: venue_adminships fk_rails_db0785df6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venue_adminships
    ADD CONSTRAINT fk_rails_db0785df6a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: articles_tracks fk_rails_dfa37c8829; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles_tracks
    ADD CONSTRAINT fk_rails_dfa37c8829 FOREIGN KEY (article_id) REFERENCES public.articles(id);


--
-- Name: job_fair_signups fk_rails_e4308ede1c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_fair_signups
    ADD CONSTRAINT fk_rails_e4308ede1c FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: zoom_join_urls fk_rails_f0871785f1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zoom_join_urls
    ADD CONSTRAINT fk_rails_f0871785f1 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: presenterships fk_rails_f0f487c2cd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.presenterships
    ADD CONSTRAINT fk_rails_f0f487c2cd FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: articles fk_rails_f23b81b642; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT fk_rails_f23b81b642 FOREIGN KEY (submission_id) REFERENCES public.submissions(id);


--
-- Name: zoom_events fk_rails_f998f9c4f0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zoom_events
    ADD CONSTRAINT fk_rails_f998f9c4f0 FOREIGN KEY (oauth_service_id) REFERENCES public.oauth_services(id);


--
-- Name: submissions fk_rails_fdef407c4c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT fk_rails_fdef407c4c FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20130116164738'),
('20130116164739'),
('20130116164740'),
('20130116164741'),
('20130116164742'),
('20130116164743'),
('20130116164744'),
('20130116164745'),
('20130116164746'),
('20130116164747'),
('20130116164748'),
('20130117040102'),
('20130508051211'),
('20130511175418'),
('20130511175511'),
('20130512230944'),
('20130514013000'),
('20130528190244'),
('20130601210506'),
('20130621041352'),
('20130624052955'),
('20130624062458'),
('20130624062459'),
('20130624065911'),
('20130624155048'),
('20130624155135'),
('20130717031259'),
('20130717164913'),
('20130717170045'),
('20130718145826'),
('20130723182248'),
('20130730175935'),
('20130806165927'),
('20130813182826'),
('20130814182029'),
('20130814183554'),
('20130815173006'),
('20130815173041'),
('20130820015528'),
('20130901170747'),
('20130905145009'),
('20130905145241'),
('20131203145334'),
('20140415172844'),
('20140415173508'),
('20140429002904'),
('20140513155451'),
('20140526225628'),
('20140624165038'),
('20140718155905'),
('20140803222351'),
('20140803224445'),
('20140816164036'),
('20140908044535'),
('20140908045403'),
('20140908045735'),
('20140909151338'),
('20140912060222'),
('20140912062536'),
('20150811052343'),
('20160617045028'),
('20160619043445'),
('20160627234846'),
('20160628040744'),
('20160710013925'),
('20160719182417'),
('20160719182706'),
('20160720160503'),
('20160726164453'),
('20160802021908'),
('20160802040055'),
('20160802042349'),
('20160802043811'),
('20160802050802'),
('20160804150055'),
('20160823024038'),
('20160823024807'),
('20160823044119'),
('20160909225854'),
('20160912034451'),
('20170320052451'),
('20170713164355'),
('20170718164505'),
('20170720060259'),
('20170811224733'),
('20170814173357'),
('20170818174841'),
('20170822225752'),
('20170828185347'),
('20170828224353'),
('20170828225347'),
('20170828225639'),
('20170830195828'),
('20170906024523'),
('20170907044328'),
('20170908145727'),
('20170911231704'),
('20170912152330'),
('20170912153018'),
('20170912155744'),
('20170915145833'),
('20170918194840'),
('20170918201311'),
('20170920024945'),
('20170925061912'),
('20171010165924'),
('20171018232858'),
('20171023230412'),
('20171023230539'),
('20171024210033'),
('20171029211526'),
('20171130230321'),
('20171212024445'),
('20180218043834'),
('20180218194540'),
('20180220163023'),
('20180316161624'),
('20180316194849'),
('20180321221958'),
('20180323161809'),
('20180330161739'),
('20180420151548'),
('20180503152209'),
('20180518145838'),
('20180527202206'),
('20180604045548'),
('20180718044128'),
('20180718045251'),
('20180718142543'),
('20180813001629'),
('20180910142243'),
('20180910175949'),
('20180916230057'),
('20180918152617'),
('20180919041913'),
('20180919042513'),
('20180919050424'),
('20180923214023'),
('20180924163222'),
('20180925205310'),
('20190221040025'),
('20190221064154'),
('20190529192917'),
('20190531150512'),
('20190531155316'),
('20190531155323'),
('20190531155330'),
('20190623185327'),
('20190624043458'),
('20190624043624'),
('20190624043648'),
('20190624140827'),
('20190628183323'),
('20190705233058'),
('20190707215408'),
('20190709191401'),
('20190711041549'),
('20190714202606'),
('20190715223850'),
('20190725031523'),
('20190804191816'),
('20190804192339'),
('20190806235214'),
('20190807021143'),
('20190807170839'),
('20190826014104'),
('20190903170552'),
('20190909204737'),
('20200414032806'),
('20200501114353'),
('20200501114543'),
('20200531215058'),
('20200531225500'),
('20200603142652'),
('20200629164627'),
('20200805034833'),
('20200901014301'),
('20200903000433'),
('20200903231844'),
('20200904213035'),
('20200906203546'),
('20200907044032'),
('20200907050103'),
('20200908010953'),
('20200908022314'),
('20200908044250'),
('20200908052350'),
('20200908171222'),
('20200910035950'),
('20200910051245'),
('20200913001959'),
('20200913010500'),
('20200913023849');


