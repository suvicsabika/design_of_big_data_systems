# EventHive - Inteligent event management and ticket sales platform

## Context and Problem Statement

EventHive is an intelligent event management and ticket sales platform designed to support the creation, publication, operation, and monitoring of events such as concerts, conferences, and workshops. The platform must provide a reliable and scalable way for organizers to create and publish events while supporting a rapidly growing user base, multiple concurrent large users, and integration with external services.

## Considered Options

* Microservices Architecture style
* Space-Based Architecture style
* Event-Drive Architecture style

## Decision Outcome

 * The Microservices architecture style would be too expensive.
 * The Space-Based architecture style would not perform as well as needed.
 * The Event-Based architecture style would suffice, offering the performance and scalability we require.
