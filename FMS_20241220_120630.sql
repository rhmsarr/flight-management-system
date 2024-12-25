--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: findtype(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.findtype(weight integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    BEGIN
        CASE
            WHEN weight = 0 THEN
                return 0;
            WHEN weight<=3 THEN 
                RETURN 1;
            WHEN weight BETWEEN 3 AND 8 THEN
                RETURN 2;
            WHEN weight BETWEEN 8 AND 23 THEN 
                RETURN 3;
        END CASE;
    END;
$$;


ALTER FUNCTION public.findtype(weight integer) OWNER TO postgres;

--
-- Name: totalprice(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.totalprice(seattype integer, flightid integer, extraweight integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
    DECLARE
        price DECIMAL;
        flightPrice INT;
        baggagePrice INT;
        baggageTypeID INT;
    BEGIN
        SELECT "Flight"."Price" INTO flightPrice FROM "Flight" WHERE "FlightID" = flightID;
        baggageTypeID := findType(extraWeight);
        SELECT "BaggagePrice" INTO baggagePrice FROM "BaggageType" WHERE "BaggageTypeID" = baggageTypeID;
        price := flightPrice * seatType;
        IF baggageTypeID > 0 THEN
            price := price + baggagePrice;
        END IF;
        return price;
    END;
$$;


ALTER FUNCTION public.totalprice(seattype integer, flightid integer, extraweight integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Airline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Airline" (
    "AirlineID" integer NOT NULL,
    "AirlineName" character varying(50)
);


ALTER TABLE public."Airline" OWNER TO postgres;

--
-- Name: Airline_AirlineID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Airline_AirlineID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Airline_AirlineID_seq" OWNER TO postgres;

--
-- Name: Airline_AirlineID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Airline_AirlineID_seq" OWNED BY public."Airline"."AirlineID";


--
-- Name: Airport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Airport" (
    "AirportID" integer NOT NULL,
    "CountryName" character varying(50),
    "CityName" character varying(50),
    "AirportName" character varying(50)
);


ALTER TABLE public."Airport" OWNER TO postgres;

--
-- Name: Airport_AirportID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Airport_AirportID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Airport_AirportID_seq" OWNER TO postgres;

--
-- Name: Airport_AirportID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Airport_AirportID_seq" OWNED BY public."Airport"."AirportID";


--
-- Name: Baggage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Baggage" (
    "BaggageID" integer NOT NULL,
    "BaggageTypeID" integer,
    "Extra" boolean,
    "TicketID" integer,
    "BaggageWeight" integer
);


ALTER TABLE public."Baggage" OWNER TO postgres;

--
-- Name: BaggageType; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BaggageType" (
    "BaggageTypeID" integer NOT NULL,
    "BaggageTypeName" character varying(20),
    "BaggagePrice" numeric
);


ALTER TABLE public."BaggageType" OWNER TO postgres;

--
-- Name: BaggageType_BaggageTypeID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."BaggageType_BaggageTypeID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."BaggageType_BaggageTypeID_seq" OWNER TO postgres;

--
-- Name: BaggageType_BaggageTypeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."BaggageType_BaggageTypeID_seq" OWNED BY public."BaggageType"."BaggageTypeID";


--
-- Name: Baggage_BaggageID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Baggage_BaggageID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Baggage_BaggageID_seq" OWNER TO postgres;

--
-- Name: Baggage_BaggageID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Baggage_BaggageID_seq" OWNED BY public."Baggage"."BaggageID";


--
-- Name: CountryCode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CountryCode" (
    "CountryCodeID" integer NOT NULL,
    "CountryName" character varying(50),
    "CountryCode" character varying(4)
);


ALTER TABLE public."CountryCode" OWNER TO postgres;

--
-- Name: CountryCode_CountryCodeID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."CountryCode_CountryCodeID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."CountryCode_CountryCodeID_seq" OWNER TO postgres;

--
-- Name: CountryCode_CountryCodeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."CountryCode_CountryCodeID_seq" OWNED BY public."CountryCode"."CountryCodeID";


--
-- Name: Flight; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Flight" (
    "FlightID" integer NOT NULL,
    "RouteID" integer,
    "TerminalID" integer,
    "AirlineID" integer,
    "PlaneID" integer,
    "Retard" boolean,
    "DepartureTime" timestamp without time zone,
    "ArrivalTime" timestamp without time zone,
    "FlightCoordinatorID" integer,
    "Price" money
);


ALTER TABLE public."Flight" OWNER TO postgres;

--
-- Name: FlightCoordinator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."FlightCoordinator" (
    "PersonID" integer NOT NULL
);


ALTER TABLE public."FlightCoordinator" OWNER TO postgres;

--
-- Name: FlightTerminal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."FlightTerminal" (
    "FlightID" integer NOT NULL,
    "TerminalID" integer NOT NULL
);


ALTER TABLE public."FlightTerminal" OWNER TO postgres;

--
-- Name: Flight_FlightID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Flight_FlightID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Flight_FlightID_seq" OWNER TO postgres;

--
-- Name: Flight_FlightID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Flight_FlightID_seq" OWNED BY public."Flight"."FlightID";


--
-- Name: Passenger; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Passenger" (
    "PersonID" integer NOT NULL,
    "PhoneNumber" character varying(15),
    "Email" character varying(50),
    "CountryCodeID" integer,
    "PassportNumber" character varying(15)
);


ALTER TABLE public."Passenger" OWNER TO postgres;

--
-- Name: Person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Person" (
    "PersonID" integer NOT NULL,
    "Name" character varying(50),
    "Surname" character varying(50)
);


ALTER TABLE public."Person" OWNER TO postgres;

--
-- Name: Person_PersonID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Person_PersonID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Person_PersonID_seq" OWNER TO postgres;

--
-- Name: Person_PersonID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Person_PersonID_seq" OWNED BY public."Person"."PersonID";


--
-- Name: Plane; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Plane" (
    "PlaneID" integer NOT NULL,
    "PlaneType" character varying(50),
    "AirlineID" integer
);


ALTER TABLE public."Plane" OWNER TO postgres;

--
-- Name: Plane_PlaneID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Plane_PlaneID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Plane_PlaneID_seq" OWNER TO postgres;

--
-- Name: Plane_PlaneID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Plane_PlaneID_seq" OWNED BY public."Plane"."PlaneID";


--
-- Name: Route; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Route" (
    "RouteID" integer NOT NULL,
    "ArrivalPlace" integer,
    "DeparturePlace" integer
);


ALTER TABLE public."Route" OWNER TO postgres;

--
-- Name: Route_RouteID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Route_RouteID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Route_RouteID_seq" OWNER TO postgres;

--
-- Name: Route_RouteID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Route_RouteID_seq" OWNED BY public."Route"."RouteID";


--
-- Name: Seat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Seat" (
    "SeatID" integer NOT NULL,
    "PlaneID" integer,
    "TicketTypeID" integer
);


ALTER TABLE public."Seat" OWNER TO postgres;

--
-- Name: Seat_SeatID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Seat_SeatID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Seat_SeatID_seq" OWNER TO postgres;

--
-- Name: Seat_SeatID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Seat_SeatID_seq" OWNED BY public."Seat"."SeatID";


--
-- Name: Terminal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Terminal" (
    "TerminalID" integer NOT NULL,
    "AirportID" integer,
    "GateNumber" character(1)
);


ALTER TABLE public."Terminal" OWNER TO postgres;

--
-- Name: Terminal_TerminalID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Terminal_TerminalID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Terminal_TerminalID_seq" OWNER TO postgres;

--
-- Name: Terminal_TerminalID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Terminal_TerminalID_seq" OWNED BY public."Terminal"."TerminalID";


--
-- Name: Ticket; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Ticket" (
    "TicketID" integer NOT NULL,
    "SeatID" integer,
    "FlightID" integer,
    "PersonID" integer
);


ALTER TABLE public."Ticket" OWNER TO postgres;

--
-- Name: TicketType; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."TicketType" (
    "TicketTypeID" integer NOT NULL,
    "TypeName" character varying(15)
);


ALTER TABLE public."TicketType" OWNER TO postgres;

--
-- Name: TicketType_TicketTypeID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."TicketType_TicketTypeID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."TicketType_TicketTypeID_seq" OWNER TO postgres;

--
-- Name: TicketType_TicketTypeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."TicketType_TicketTypeID_seq" OWNED BY public."TicketType"."TicketTypeID";


--
-- Name: Ticket_TicketID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Ticket_TicketID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Ticket_TicketID_seq" OWNER TO postgres;

--
-- Name: Ticket_TicketID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Ticket_TicketID_seq" OWNED BY public."Ticket"."TicketID";


--
-- Name: Airline AirlineID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Airline" ALTER COLUMN "AirlineID" SET DEFAULT nextval('public."Airline_AirlineID_seq"'::regclass);


--
-- Name: Airport AirportID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Airport" ALTER COLUMN "AirportID" SET DEFAULT nextval('public."Airport_AirportID_seq"'::regclass);


--
-- Name: Baggage BaggageID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Baggage" ALTER COLUMN "BaggageID" SET DEFAULT nextval('public."Baggage_BaggageID_seq"'::regclass);


--
-- Name: BaggageType BaggageTypeID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BaggageType" ALTER COLUMN "BaggageTypeID" SET DEFAULT nextval('public."BaggageType_BaggageTypeID_seq"'::regclass);


--
-- Name: CountryCode CountryCodeID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CountryCode" ALTER COLUMN "CountryCodeID" SET DEFAULT nextval('public."CountryCode_CountryCodeID_seq"'::regclass);


--
-- Name: Flight FlightID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Flight" ALTER COLUMN "FlightID" SET DEFAULT nextval('public."Flight_FlightID_seq"'::regclass);


--
-- Name: Person PersonID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Person" ALTER COLUMN "PersonID" SET DEFAULT nextval('public."Person_PersonID_seq"'::regclass);


--
-- Name: Plane PlaneID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Plane" ALTER COLUMN "PlaneID" SET DEFAULT nextval('public."Plane_PlaneID_seq"'::regclass);


--
-- Name: Route RouteID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Route" ALTER COLUMN "RouteID" SET DEFAULT nextval('public."Route_RouteID_seq"'::regclass);


--
-- Name: Seat SeatID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seat" ALTER COLUMN "SeatID" SET DEFAULT nextval('public."Seat_SeatID_seq"'::regclass);


--
-- Name: Terminal TerminalID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Terminal" ALTER COLUMN "TerminalID" SET DEFAULT nextval('public."Terminal_TerminalID_seq"'::regclass);


--
-- Name: Ticket TicketID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ticket" ALTER COLUMN "TicketID" SET DEFAULT nextval('public."Ticket_TicketID_seq"'::regclass);


--
-- Name: TicketType TicketTypeID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TicketType" ALTER COLUMN "TicketTypeID" SET DEFAULT nextval('public."TicketType_TicketTypeID_seq"'::regclass);


--
-- Data for Name: Airline; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Airline" VALUES
	(1, 'Turkish Airlines'),
	(2, 'Qantas'),
	(3, 'British Airways'),
	(4, 'Qatar Airways'),
	(5, 'Air China'),
	(7, 'Singapore Airlines'),
	(8, 'Alitalia'),
	(9, 'Air France'),
	(10, 'Lufthansa'),
	(6, 'American Airlines');


--
-- Data for Name: Airport; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Airport" VALUES
	(17, 'Taiwan', 'Taipei', 'Taipei Taoyuan International Airport'),
	(18, 'USA', 'Seattle', 'Seattle-Tacoma International Airport'),
	(1, 'Turkey', 'İstanbul', 'İstanbul Airport'),
	(19, 'Canada', 'Toronto', 'Toronto Pearson International Airport'),
	(20, 'Russia', 'Moscow', 'Moscow Sheremetyevo International Airport'),
	(7, 'France', 'Paris', 'Paris Charles de Gaulle Airport'),
	(3, 'South Korea', 'Seoul', 'Seoul Incheon International Airport'),
	(2, 'Japan', 'Tokyo', 'Tokyo Haneda Airport'),
	(11, 'Netherlands', 'Amsterdam', 'Amsterdam Schiphol Airport'),
	(9, 'Germany', 'Munich', 'Munich Airport'),
	(10, 'Switzerland', 'Zurich', 'Zurich Airport'),
	(5, 'Qatar', 'Doha', 'Doha Hamad International Airport'),
	(6, 'Singapore', 'Singapore', 'Singapore Changi Airport'),
	(8, 'United Arab Emirates', 'Dubai', 'Dubai International Airport'),
	(14, 'Australia', 'Sydney ', 'Sydney Kingsford Smith Airport'),
	(4, 'Denmark', 'Copenhagen', 'Copenhagen Airport '),
	(15, 'Spain', 'Madrid', 'Madrid Barajas Airport'),
	(16, 'Norway', 'Oslo', 'Oslo Gardermoen Airport '),
	(13, 'United Kingdom', 'London', 'London Heathrow Airport'),
	(12, 'China', 'Hong Kong', 'Hong Kong International Airport');


--
-- Data for Name: Baggage; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: BaggageType; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."BaggageType" VALUES
	(2, 'Checked', 100),
	(1, 'Carry-On ', 50),
	(3, 'Personal Item', 40);


--
-- Data for Name: CountryCode; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."CountryCode" VALUES
	(1, 'Turkiye', '+90'),
	(2, 'United Kingdom', '+44'),
	(3, 'Germany', '+49'),
	(4, 'France', '+33'),
	(6, 'China', '+86'),
	(8, 'Australia', '+61'),
	(9, 'Canada', '+1'),
	(10, 'Italy', '+39'),
	(7, 'Jordan', '+962'),
	(5, 'Brazil', '+55');


--
-- Data for Name: Flight; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Flight" VALUES
	(5, 5, 58, 4, 4, NULL, '2024-12-19 07:45:00', '2024-12-19 14:15:00', 5, '$950.00'),
	(13, 13, 69, 3, 3, NULL, '2024-12-22 06:05:00', '2024-12-22 15:30:00', 3, '$1,850.00'),
	(2, 2, 46, 5, 5, NULL, '2024-12-17 14:15:00', '2024-12-17 18:05:00', 2, '$1,350.00'),
	(43, 13, 71, 4, 4, NULL, '2024-12-31 14:10:00', '2024-12-31 23:35:00', 3, '$1,850.00'),
	(6, 6, 63, 6, 6, NULL, '2024-12-19 09:30:00', '2024-12-19 23:40:00', 1, '$3,500.00'),
	(1, 1, 41, 1, 1, NULL, '2024-12-17 12:30:00', '2024-12-17 15:48:00', 1, '$3,203.00'),
	(31, 1, 43, 8, 8, NULL, '2024-12-27 15:10:00', '2024-12-27 18:28:00', 1, '$3,208.00'),
	(19, 19, 45, 5, 5, NULL, '2024-12-23 11:10:00', '2024-12-24 02:00:00', 4, '$4,300.00'),
	(38, 8, 70, 5, 5, NULL, '2024-12-29 10:30:00', '2024-12-30 01:45:00', 3, '$3,250.00'),
	(25, 25, 22, 7, 7, NULL, '2024-12-25 12:50:00', '2024-12-26 04:00:00', 5, '$3,500.00'),
	(47, 17, 54, 2, 2, NULL, '2025-01-01 11:45:00', '2025-01-01 22:15:00', 2, '$1,750.00'),
	(7, 7, 65, 9, 9, NULL, '2024-12-20 15:05:00', '2024-12-21 06:00:00', 2, '$12,700.00'),
	(51, 21, 39, 3, 3, NULL, '2025-01-03 14:30:00', '2025-01-03 16:20:00', 1, '$470.00'),
	(4, 4, 56, 10, 10, NULL, '2024-12-19 05:00:00', '2024-12-20 04:50:00', 4, '$3,850.00'),
	(55, 25, 24, 10, 10, NULL, '2025-01-05 15:00:00', '2025-01-06 06:10:00', 5, '$3,500.00'),
	(20, 20, 43, 7, 7, NULL, '2024-12-23 21:25:00', '2024-12-24 04:00:00', 5, '$1,300.00'),
	(14, 14, 67, 2, 2, NULL, '2024-12-22 07:13:00', '2024-12-22 16:33:00', 4, '$1,275.00'),
	(26, 26, 18, 4, 4, NULL, '2024-12-25 13:50:00', '2024-12-25 21:00:00', 1, '$1,280.00'),
	(39, 9, 73, 7, 7, NULL, '2024-12-30 16:00:00', '2024-12-30 23:40:00', 4, '$2,400.00'),
	(44, 14, 66, 10, 10, NULL, '2024-12-31 21:20:00', '2025-01-01 05:40:00', 4, '$1,275.00'),
	(3, 3, 52, 3, 3, NULL, '2024-12-18 10:00:00', '2024-12-18 22:15:00', 3, '$3,950.00'),
	(52, 22, 36, 4, 4, NULL, '2025-01-03 11:10:00', '2025-01-03 23:35:00', 2, '$3,200.00'),
	(48, 18, 52, 1, 1, NULL, '2025-01-01 15:15:00', '2025-01-01 22:00:00', 3, '$3,150.00'),
	(58, 28, 11, 6, 6, NULL, '2025-01-06 10:35:00', '2025-01-06 20:15:00', 3, '$3,400.00'),
	(34, 4, 53, 10, 10, NULL, '2024-12-28 12:00:00', '2024-12-29 11:50:00', 4, '$3,850.00'),
	(49, 19, 47, 5, 5, NULL, '2025-01-02 16:10:00', '2025-01-03 07:00:00', 4, '$4,300.00'),
	(45, 15, 61, 8, 8, NULL, '2024-12-31 08:30:00', '2024-12-31 12:20:00', 5, '$530.00'),
	(56, 26, 20, 4, 4, NULL, '2025-01-05 10:00:00', '2025-01-05 17:10:00', 1, '$1,280.00'),
	(35, 5, 55, 4, 4, NULL, '2024-12-28 14:05:00', '2024-12-28 20:35:00', 5, '$950.00'),
	(53, 23, 29, 9, 9, NULL, '2025-01-04 12:15:00', '2025-01-04 08:05:00', 3, '$3,050.00'),
	(40, 10, 78, 1, 1, NULL, '2024-12-30 15:20:00', '2024-12-30 18:24:00', 5, '$2,650.00'),
	(59, 29, 7, 10, 10, NULL, '2025-01-07 10:55:00', '2025-01-07 23:25:00', 4, '$3,500.00'),
	(46, 16, 59, 6, 6, NULL, '2025-01-01 13:15:00', '2025-01-01 17:00:00', 1, '$390.00'),
	(50, 20, 41, 7, 7, NULL, '2025-01-02 07:25:00', '2025-01-02 14:00:00', 5, '$1,300.00'),
	(41, 11, 77, 3, 3, NULL, '2024-12-30 18:45:00', '2024-12-30 22:15:00', 1, '$2,150.00'),
	(60, 30, 1, 1, 1, NULL, '2025-01-07 16:15:00', '2025-01-07 21:00:00', 5, '$1,300.00'),
	(36, 6, 62, 6, 6, NULL, '2024-12-29 11:45:00', '2024-12-29 01:55:00', 1, '$3,500.00'),
	(54, 24, 27, 9, 9, NULL, '2025-01-04 16:55:00', '2025-01-05 03:00:00', 4, '$4,300.00'),
	(57, 27, 14, 5, 5, NULL, '2025-01-06 05:20:00', '2025-01-06 22:00:00', 2, '$2,800.00'),
	(42, 12, 73, 9, 9, NULL, '2024-12-31 12:00:00', '2025-01-01 04:50:00', 2, '$3,500.00'),
	(8, 8, 72, 6, 6, NULL, '2024-12-20 17:10:00', '2024-12-21 08:25:00', 3, '$3,250.00'),
	(37, 7, 67, 2, 2, NULL, '2024-12-29 06:05:00', '2024-12-29 21:00:00', 2, '$12,700.00'),
	(27, 27, 13, 7, 7, NULL, '2024-12-25 18:20:00', '2024-12-26 13:00:00', 2, '$2,800.00'),
	(15, 15, 63, 8, 8, NULL, '2024-12-22 20:00:00', '2024-12-22 23:50:00', 5, '$530.00'),
	(21, 21, 37, 8, 8, NULL, '2024-12-23 22:00:00', '2024-12-23 23:50:00', 1, '$470.00'),
	(28, 28, 10, 6, 6, NULL, '2024-12-25 23:20:00', '2024-12-26 09:00:00', 3, '$3,400.00'),
	(22, 22, 34, 10, 10, NULL, '2024-12-24 06:05:00', '2024-12-24 18:30:00', 2, '$3,200.00'),
	(29, 29, 5, 10, 10, NULL, '2024-12-26 06:00:00', '2024-12-26 18:30:00', 4, '$3,500.00'),
	(9, 9, 74, 10, 10, NULL, '2024-12-21 10:25:00', '2024-12-21 18:05:00', 4, '$2,400.00'),
	(16, 16, 58, 7, 7, NULL, '2024-12-23 04:00:00', '2024-12-23 07:45:00', 1, '$390.00'),
	(23, 23, 31, 3, 3, NULL, '2024-12-24 08:10:00', '2024-12-24 16:00:00', 3, '$3,050.00'),
	(10, 10, 80, 1, 1, NULL, '2024-12-21 14:11:00', '2024-12-21 17:15:00', 5, '$2,650.00'),
	(30, 30, 2, 1, 1, NULL, '2024-12-26 10:00:00', '2024-12-26 14:45:00', 5, '$1,300.00'),
	(17, 17, 55, 2, 2, NULL, '2024-12-23 04:30:00', '2024-12-23 14:00:00', 2, '$1,750.00'),
	(32, 2, 48, 3, 3, NULL, '2024-12-27 18:30:00', '2024-12-27 22:40:00', 2, '$1,350.00'),
	(11, 11, 79, 7, 7, NULL, '2024-12-21 20:00:00', '2024-12-21 23:30:00', 1, '$2,150.00'),
	(24, 24, 26, 9, 9, NULL, '2024-12-25 09:55:00', '2024-12-25 21:00:00', 4, '$4,300.00'),
	(12, 12, 75, 5, 5, NULL, '2024-12-21 23:10:00', '2024-12-22 16:00:00', 2, '$3,500.00'),
	(18, 18, 50, 6, 6, NULL, '2024-12-23 06:45:00', '2024-12-23 15:30:00', 3, '$3,150.00'),
	(33, 3, 50, 6, 6, NULL, '2024-12-27 16:15:00', '2024-12-28 04:30:00', 3, '$3,950.00');


--
-- Data for Name: FlightCoordinator; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."FlightCoordinator" VALUES
	(1),
	(2),
	(3),
	(4),
	(5);


--
-- Data for Name: FlightTerminal; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Passenger; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Passenger" VALUES
	(6, '138 1234 5678', 'jun.gao456@gmail.com', 6, 'E12345678'),
	(7, '347 123 4567', 'rossi.sofia321@gmail.com', 10, 'Y87654321'),
	(9, '139 8765 4321', 'isla.anderson123@gmail.com', 8, 'B23456789'),
	(10, '145 5432 1098', 'lukas.weber456@gmail.com', 3, 'F45678901'),
	(8, '348 765 4321', 'carlos.silva987@gmail.com', 5, 'X98765432');


--
-- Data for Name: Person; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Person" VALUES
	(1, 'Elif', 'Doğan'),
	(2, 'Fatma', 'Özdemir'),
	(3, 'Hakan', 'Arslan'),
	(4, 'Emre', 'Yılmaz'),
	(5, 'Ahmet', 'Kaya'),
	(6, 'Jun', 'Gao'),
	(7, 'Sofia', 'Rossi'),
	(8, 'Carlos', 'Silva'),
	(9, 'Isla', 'Anderson'),
	(10, 'Lukas', 'Weber');


--
-- Data for Name: Plane; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Plane" VALUES
	(1, 'Boeing 737', 1),
	(2, 'Airbus A320', 2),
	(3, 'Boeing 777', 3),
	(4, 'Airbus A350', 4),
	(5, 'Boeing 787 Dreamliner', 5),
	(6, 'Boeing 737', 6),
	(7, 'Airbus A320', 7),
	(8, 'Boeing 777', 8),
	(9, 'Airbus A350', 9),
	(10, 'Boeing 787 Dreamliner', 10);


--
-- Data for Name: Route; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Route" VALUES
	(20, 20, 11),
	(21, 11, 10),
	(22, 12, 9),
	(23, 13, 8),
	(24, 14, 7),
	(25, 15, 6),
	(26, 16, 5),
	(27, 17, 4),
	(28, 18, 3),
	(30, 20, 1),
	(29, 19, 2),
	(2, 2, 12),
	(3, 3, 13),
	(4, 4, 14),
	(5, 5, 15),
	(6, 6, 16),
	(7, 7, 17),
	(8, 8, 18),
	(9, 9, 19),
	(10, 10, 20),
	(11, 11, 20),
	(12, 12, 19),
	(13, 13, 18),
	(14, 14, 17),
	(15, 15, 16),
	(16, 16, 15),
	(17, 17, 14),
	(18, 18, 13),
	(19, 19, 12),
	(1, 1, 11);


--
-- Data for Name: Seat; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Seat" VALUES
	(92, 5, 3),
	(2, 1, 1),
	(1, 1, 1),
	(3, 1, 2),
	(4, 1, 2),
	(5, 1, 2),
	(6, 1, 3),
	(7, 1, 3),
	(8, 1, 3),
	(9, 1, 3),
	(10, 1, 3),
	(11, 1, 3),
	(12, 1, 3),
	(13, 1, 3),
	(14, 1, 3),
	(15, 1, 3),
	(93, 5, 3),
	(94, 5, 3),
	(95, 5, 3),
	(96, 5, 3),
	(97, 5, 3),
	(98, 5, 3),
	(99, 5, 3),
	(100, 5, 3),
	(101, 5, 3),
	(102, 5, 3),
	(103, 5, 3),
	(104, 5, 3),
	(16, 2, 1),
	(17, 2, 1),
	(18, 2, 2),
	(19, 2, 2),
	(20, 2, 2),
	(21, 2, 3),
	(22, 2, 3),
	(23, 2, 3),
	(24, 2, 3),
	(25, 2, 3),
	(26, 2, 3),
	(27, 2, 3),
	(28, 2, 3),
	(29, 2, 3),
	(30, 2, 3),
	(31, 2, 3),
	(32, 2, 3),
	(105, 5, 3),
	(106, 5, 3),
	(61, 4, 1),
	(62, 4, 1),
	(63, 4, 2),
	(64, 4, 2),
	(65, 4, 2),
	(66, 4, 2),
	(67, 4, 3),
	(68, 4, 3),
	(69, 4, 3),
	(70, 4, 3),
	(71, 4, 3),
	(72, 4, 3),
	(73, 4, 3),
	(74, 4, 3),
	(33, 3, 1),
	(34, 3, 1),
	(35, 3, 2),
	(36, 3, 2),
	(37, 3, 2),
	(38, 3, 2),
	(39, 3, 2),
	(40, 3, 3),
	(41, 3, 3),
	(42, 3, 3),
	(43, 3, 3),
	(44, 3, 3),
	(45, 3, 3),
	(46, 3, 3),
	(47, 3, 3),
	(48, 3, 3),
	(49, 3, 3),
	(50, 3, 3),
	(51, 3, 3),
	(52, 3, 3),
	(53, 3, 3),
	(75, 4, 3),
	(54, 3, 3),
	(55, 3, 3),
	(56, 3, 3),
	(57, 3, 3),
	(58, 3, 3),
	(59, 3, 3),
	(60, 3, 3),
	(107, 5, 3),
	(76, 4, 3),
	(77, 4, 3),
	(78, 4, 3),
	(79, 4, 3),
	(80, 4, 3),
	(81, 4, 3),
	(82, 4, 3),
	(83, 4, 3),
	(84, 4, 3),
	(85, 5, 1),
	(86, 5, 1),
	(87, 5, 2),
	(88, 5, 2),
	(89, 5, 2),
	(90, 5, 2),
	(91, 5, 3);


--
-- Data for Name: Terminal; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Terminal" VALUES
	(35, 9, 'C'),
	(36, 9, 'D'),
	(37, 10, 'A'),
	(38, 10, 'B'),
	(39, 10, 'C'),
	(40, 10, 'D'),
	(1, 1, 'A'),
	(2, 1, 'B'),
	(3, 1, 'C'),
	(4, 1, 'D'),
	(5, 2, 'A'),
	(6, 2, 'B'),
	(7, 2, 'C'),
	(8, 2, 'D'),
	(9, 3, 'A'),
	(10, 3, 'B'),
	(11, 3, 'C'),
	(12, 3, 'D'),
	(13, 4, 'A'),
	(14, 4, 'B'),
	(15, 4, 'C'),
	(16, 4, 'D'),
	(17, 5, 'A'),
	(18, 5, 'B'),
	(19, 5, 'C'),
	(20, 5, 'D'),
	(21, 6, 'A'),
	(22, 6, 'B'),
	(23, 6, 'C'),
	(24, 6, 'D'),
	(25, 7, 'A'),
	(26, 7, 'B'),
	(27, 7, 'C'),
	(28, 7, 'D'),
	(29, 8, 'A'),
	(30, 8, 'B'),
	(31, 8, 'C'),
	(32, 8, 'D'),
	(33, 9, 'A'),
	(34, 9, 'B'),
	(41, 11, 'A'),
	(42, 11, 'B'),
	(43, 11, 'C'),
	(44, 11, 'D'),
	(45, 12, 'A'),
	(46, 12, 'B'),
	(47, 12, 'C'),
	(48, 12, 'D'),
	(49, 13, 'A'),
	(50, 13, 'B'),
	(51, 13, 'C'),
	(52, 13, 'D'),
	(53, 14, 'A'),
	(54, 14, 'B'),
	(55, 14, 'C'),
	(56, 14, 'D'),
	(57, 15, 'A'),
	(58, 15, 'B'),
	(59, 15, 'C'),
	(60, 15, 'D'),
	(61, 16, 'A'),
	(62, 16, 'B'),
	(63, 16, 'C'),
	(64, 16, 'D'),
	(65, 17, 'A'),
	(66, 17, 'B'),
	(67, 17, 'C'),
	(68, 17, 'D'),
	(69, 18, 'A'),
	(70, 18, 'B'),
	(71, 18, 'C'),
	(72, 18, 'D'),
	(73, 19, 'A'),
	(74, 19, 'B'),
	(75, 19, 'C'),
	(76, 19, 'D'),
	(77, 20, 'A'),
	(78, 20, 'B'),
	(79, 20, 'C'),
	(80, 20, 'D');


--
-- Data for Name: Ticket; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: TicketType; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."TicketType" VALUES
	(2, 'Business Class'),
	(1, 'First Class'),
	(3, 'Economy Class');


--
-- Name: Airline_AirlineID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Airline_AirlineID_seq"', 10, true);


--
-- Name: Airport_AirportID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Airport_AirportID_seq"', 1, true);


--
-- Name: BaggageType_BaggageTypeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."BaggageType_BaggageTypeID_seq"', 3, true);


--
-- Name: Baggage_BaggageID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Baggage_BaggageID_seq"', 1, false);


--
-- Name: CountryCode_CountryCodeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."CountryCode_CountryCodeID_seq"', 10, true);


--
-- Name: Flight_FlightID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Flight_FlightID_seq"', 60, true);


--
-- Name: Person_PersonID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Person_PersonID_seq"', 10, true);


--
-- Name: Plane_PlaneID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Plane_PlaneID_seq"', 10, true);


--
-- Name: Route_RouteID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Route_RouteID_seq"', 1, false);


--
-- Name: Seat_SeatID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Seat_SeatID_seq"', 107, true);


--
-- Name: Terminal_TerminalID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Terminal_TerminalID_seq"', 13, true);


--
-- Name: TicketType_TicketTypeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."TicketType_TicketTypeID_seq"', 4, true);


--
-- Name: Ticket_TicketID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Ticket_TicketID_seq"', 1, false);


--
-- Name: Airline AirlinePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Airline"
    ADD CONSTRAINT "AirlinePK" PRIMARY KEY ("AirlineID");


--
-- Name: Airport AirportPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Airport"
    ADD CONSTRAINT "AirportPK" PRIMARY KEY ("AirportID");


--
-- Name: Baggage BaggagePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Baggage"
    ADD CONSTRAINT "BaggagePK" PRIMARY KEY ("BaggageID");


--
-- Name: BaggageType BaggageTypePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BaggageType"
    ADD CONSTRAINT "BaggageTypePK" PRIMARY KEY ("BaggageTypeID");


--
-- Name: CountryCode CountryCodePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CountryCode"
    ADD CONSTRAINT "CountryCodePK" PRIMARY KEY ("CountryCodeID");


--
-- Name: FlightCoordinator FlightCoordinatorPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FlightCoordinator"
    ADD CONSTRAINT "FlightCoordinatorPK" PRIMARY KEY ("PersonID");


--
-- Name: Flight FlightPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Flight"
    ADD CONSTRAINT "FlightPK" PRIMARY KEY ("FlightID");


--
-- Name: FlightTerminal FlightTerminalPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FlightTerminal"
    ADD CONSTRAINT "FlightTerminalPK" PRIMARY KEY ("FlightID", "TerminalID");


--
-- Name: Plane PlanePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Plane"
    ADD CONSTRAINT "PlanePK" PRIMARY KEY ("PlaneID");


--
-- Name: Route RoutePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Route"
    ADD CONSTRAINT "RoutePK" PRIMARY KEY ("RouteID");


--
-- Name: Seat SeatPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seat"
    ADD CONSTRAINT "SeatPK" PRIMARY KEY ("SeatID");


--
-- Name: Terminal TerminalPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Terminal"
    ADD CONSTRAINT "TerminalPK" PRIMARY KEY ("TerminalID");


--
-- Name: Ticket TicketPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ticket"
    ADD CONSTRAINT "TicketPK" PRIMARY KEY ("TicketID");


--
-- Name: TicketType TıcketTypePK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TicketType"
    ADD CONSTRAINT "TıcketTypePK" PRIMARY KEY ("TicketTypeID");


--
-- Name: Passenger passengerPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Passenger"
    ADD CONSTRAINT "passengerPK" PRIMARY KEY ("PersonID");


--
-- Name: Person personPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Person"
    ADD CONSTRAINT "personPK" PRIMARY KEY ("PersonID");


--
-- Name: Terminal AirportTerminalFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Terminal"
    ADD CONSTRAINT "AirportTerminalFK" FOREIGN KEY ("AirportID") REFERENCES public."Airport"("AirportID") ON DELETE CASCADE;


--
-- Name: Baggage BaggageBaggageTypeFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Baggage"
    ADD CONSTRAINT "BaggageBaggageTypeFK" FOREIGN KEY ("BaggageTypeID") REFERENCES public."BaggageType"("BaggageTypeID") ON UPDATE CASCADE;


--
-- Name: Baggage BaggageTicketFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Baggage"
    ADD CONSTRAINT "BaggageTicketFK" FOREIGN KEY ("TicketID") REFERENCES public."Ticket"("TicketID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Flight FlightAirlineFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Flight"
    ADD CONSTRAINT "FlightAirlineFK" FOREIGN KEY ("AirlineID") REFERENCES public."Airline"("AirlineID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: FlightCoordinator FlightCoordinatorPerson; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FlightCoordinator"
    ADD CONSTRAINT "FlightCoordinatorPerson" FOREIGN KEY ("PersonID") REFERENCES public."Person"("PersonID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Flight FlightFlightCoordinatorFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Flight"
    ADD CONSTRAINT "FlightFlightCoordinatorFK" FOREIGN KEY ("FlightCoordinatorID") REFERENCES public."FlightCoordinator"("PersonID") ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Flight FlightPlaneFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Flight"
    ADD CONSTRAINT "FlightPlaneFK" FOREIGN KEY ("PlaneID") REFERENCES public."Plane"("PlaneID") ON DELETE CASCADE;


--
-- Name: Flight FlightRouteFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Flight"
    ADD CONSTRAINT "FlightRouteFK" FOREIGN KEY ("RouteID") REFERENCES public."Route"("RouteID");


--
-- Name: Flight FlightTerminalFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Flight"
    ADD CONSTRAINT "FlightTerminalFK" FOREIGN KEY ("TerminalID") REFERENCES public."Terminal"("TerminalID");


--
-- Name: FlightTerminal FlightTerminalFlightFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FlightTerminal"
    ADD CONSTRAINT "FlightTerminalFlightFK" FOREIGN KEY ("FlightID") REFERENCES public."Flight"("FlightID");


--
-- Name: FlightTerminal FlightTerminalTerminalFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."FlightTerminal"
    ADD CONSTRAINT "FlightTerminalTerminalFK" FOREIGN KEY ("TerminalID") REFERENCES public."Terminal"("TerminalID");


--
-- Name: Ticket FlightTicketFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ticket"
    ADD CONSTRAINT "FlightTicketFK" FOREIGN KEY ("FlightID") REFERENCES public."Flight"("FlightID") ON UPDATE CASCADE;


--
-- Name: Ticket PersonTicketFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ticket"
    ADD CONSTRAINT "PersonTicketFK" FOREIGN KEY ("PersonID") REFERENCES public."Person"("PersonID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Plane PlaneAirlineFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Plane"
    ADD CONSTRAINT "PlaneAirlineFK" FOREIGN KEY ("AirlineID") REFERENCES public."Airline"("AirlineID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Seat PlaneSeatFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seat"
    ADD CONSTRAINT "PlaneSeatFK" FOREIGN KEY ("PlaneID") REFERENCES public."Plane"("PlaneID") ON DELETE CASCADE;


--
-- Name: Ticket SeatTicketFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ticket"
    ADD CONSTRAINT "SeatTicketFK" FOREIGN KEY ("SeatID") REFERENCES public."Seat"("SeatID") ON UPDATE CASCADE;


--
-- Name: Seat SeatTypeFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Seat"
    ADD CONSTRAINT "SeatTypeFK" FOREIGN KEY ("TicketTypeID") REFERENCES public."TicketType"("TicketTypeID") ON DELETE CASCADE;


--
-- Name: Route arrivalFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Route"
    ADD CONSTRAINT "arrivalFK" FOREIGN KEY ("ArrivalPlace") REFERENCES public."Airport"("AirportID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Route departureFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Route"
    ADD CONSTRAINT "departureFK" FOREIGN KEY ("DeparturePlace") REFERENCES public."Airport"("AirportID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Passenger passengerCountryCodeFK; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Passenger"
    ADD CONSTRAINT "passengerCountryCodeFK" FOREIGN KEY ("CountryCodeID") REFERENCES public."CountryCode"("CountryCodeID");


--
-- Name: Passenger passengerPerson; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Passenger"
    ADD CONSTRAINT "passengerPerson" FOREIGN KEY ("PersonID") REFERENCES public."Person"("PersonID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

