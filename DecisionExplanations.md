# Architectural Decision Explanation and ADR Justification

Decisions were supported by the following book:

Software Engineering (10th edition) – Ian Sommerville

## System: EventHive – Intelligent Event Management and Ticket Sales Platform

# Decision Summary

The selected architectural style:

Event-Driven Architecture (EDA)

Considered, but rejected alternatives:
- Microservices Architecture
- Space-Based Architecture

# Source mapping to the Book

This decision is primarily supported by:

- Chapter 15.1 – The Reuse Landscape (Architectural patterns)
- Chapter 17.1 – Distributed systems
- Chapter 17.1.1 – Models of interaction

# 1. Why Event-Driven Architecture was chosen

## Reference:
- Chapter 17.1 – Distributed systems
- Chapter 17.1.1 – Models of interaction

## Key Concept: Message-Based Interaction

### Supporting text (Chapter 17.1.1)

> “Message-based interaction involves the ‘sending’ computer defining information about what is required in a message, which is then sent to another computer. The receiving computer decides what to do with the message. Messages usually transmit more information in a single interaction than a procedure call to another machine. This can reduce the number of interactions required between systems.”

## Interpretation

The text defines a communication model where:

- Interaction is asynchronous  
- The sender does not wait for execution  
- The receiver independently determines processing  

This directly corresponds to Event-Driven Architecture:

- Events act as messages  
- Producers send events without blocking  
- Consumers process events independently  

## Supporting text (Chapter 17.1)

> “In a distributed system, several processes may operate at the same time on separate computers on the network. Distributed systems are scalable in that the capabilities of the system can be increased by adding new resources to cope with new demands. The availability of several computers and the potential for replicating information means that distributed systems can be tolerant of some hardware and software failures. However, distributed systems are inherently more complex than centralized systems. This makes them more difficult to design, implement, and test.”

## Interpretation

This passage identifies three key properties:

- Concurrency  
- Scalability  
- Fault tolerance  

EDA utilizes these properties while reducing complexity through loose coupling enabled by asynchronous messaging (17.1.1).

## Alignment with Functional Requirements

| Functional Requirement | Why EDA fits |
|----------------------|-------------|
| FR2 Ticket Sales | Implemented as event sequence (purchase → payment → ticket issuance) |
| FR3 Admission Control | Event-based validation enables real-time processing |
| FR6 Notifications | Naturally asynchronous via message propagation |
| FR7 Analytics | Event streams support continuous data processing |
| FR4 Dynamic Pricing | Pricing reacts to incoming event streams |

## Alignment with Non-Functional Requirements

Based on Chapter 17.1:

- Performance is improved through concurrent processing  
- Scalability is achieved by adding independent consumers  
- Availability is improved through distribution and failure isolation  
- Integration is enabled through message-based communication  

## Key Insight

EDA is selected because it applies **message-based interaction (17.1.1)** to exploit **distributed system properties (17.1)** while reducing runtime coupling.

# 2. Why Microservices were rejected

## Reference:
- Chapter 17.1 – Distributed systems
- Chapter 17.1.1 – Models of interaction

## Critical Distinction

Both architectures are distributed. The difference lies in interaction:

- Microservices: typically synchronous interaction  
- EDA: asynchronous message-based interaction  

## Supporting text (Chapter 17.1)

> “Distributed systems are inherently more complex than centralized systems. This makes them more difficult to design, implement, and test. Distributed systems are more difficult to control, and it is more difficult to manage their security. Because separate computers are involved, there are more possibilities for system failure.”

## Supporting text (Chapter 17.1.1)

> “Remote procedure calls require a synchronous interaction between the client and the server. The client program waits for the called procedure to execute before continuing. This means that the overall performance of the system depends on the speed of the remote system.”

> “Message-based interaction does not require an immediate response. The sending system can continue processing after sending the message.”

## Interpretation

Microservices are typically implemented using RPC or REST, which follow the synchronous interaction model described in 17.1.1.

This implies:

- The caller must wait for the callee  
- Execution is blocked during communication  
- System performance depends on remote services  

In contrast, EDA follows the message-based model:

- No waiting is required  
- Processing is decoupled  
- Components operate independently  

## Architectural Consequences

### Synchronous interaction (Microservices)

- Tight runtime coupling  
- Increased latency due to blocking  
- Cascading failures due to dependencies  
- Higher coordination complexity  

### Asynchronous interaction (EDA)

- Loose coupling  
- Independent execution  
- Failure isolation  
- Improved scalability  

## Why Microservices Become Expensive

### 1. Increased complexity (Chapter 17.1)

> “Distributed systems are inherently more complex…”

Microservices increase:

- Number of components  
- Communication paths  
- Coordination requirements  

### 2. Performance dependency (Chapter 17.1.1)

> “The client program waits…”

This creates:

- Latency accumulation  
- Dependency on slowest service  

### 3. Failure probability (Chapter 17.1)

> “There are more possibilities for system failure.”

Microservices amplify this through:

- Multiple service dependencies  
- Increased communication points  

### 4. Operational overhead (derived from 17.1)

Distributed systems require:

- Monitoring  
- Deployment coordination  
- Failure handling mechanisms  

Microservices intensify all these requirements.

## ADR Justification

Microservices were rejected because:

- They increase **distributed system complexity (17.1)**  
- They rely on **synchronous interaction (17.1.1)**  
- They introduce **runtime coupling and failure propagation**  
- They require **significant operational overhead**  

# 3. Why Space-Based Architecture was rejected

## Reference:
- Chapter 17.1 – Distributed systems

## Supporting text (Chapter 17.1)

> “System performance depends on network bandwidth, network load, and the speed of other computers that are part of the system. Response time depends on the overall load on the system, its architecture, and the network load.”

## Interpretation

Performance is determined by:

- System architecture  
- Communication patterns  
- Load distribution  

## Mismatch with EventHive

Space-Based Architecture is optimized for:

- Data locality  
- In-memory storage  
- High-speed data access  

EventHive requires:

- Message propagation  
- Event-driven workflows  
- Integration across systems  

## Conclusion

Space-Based Architecture does not align with:

- Message-based interaction (17.1.1)  
- Workflow-oriented processing  

## ADR Justification

Space-Based Architecture was rejected because:

- Performance depends on architecture (17.1)  
- It does not support event-driven interaction effectively  
- It is optimized for data-centric rather than event-centric systems  

# 4. Architectural Decision Approach

## Reference:
- Chapter 15.1 – The Reuse Landscape

## Supporting text (Chapter 15.1)

> “Architectural patterns are used as the basis of applications. The choice of an appropriate architectural pattern depends on the system requirements, available technologies, and the expertise of the development team.”

## Interpretation

The decision process:

- Evaluates alternative architectural patterns  
- Selects the one that best satisfies requirements  

This directly follows the architectural selection approach described in 15.1.

## Additional Architectural Considerations

### Integration (Chapter 17.1)

> “Distributed systems are open systems…”

EDA supports integration through loose coupling and event-based communication.

### Consistency Trade-off

Event-driven systems favor scalability and availability but introduce challenges in maintaining strong consistency, which must be handled explicitly in ticket inventory management.

### Maintainability

Loose coupling between event producers and consumers improves system maintainability and allows independent evolution of components.

### Security and Audit

Distributed systems increase security complexity (17.1), but event logs provide a natural audit trail for compliance requirements.

# Final Mapping

| ADR Decision | Supporting Section |
|-------------|------------------|
| Event-Driven Architecture selected | Chapter 17.1.1 – Message-based interaction |
| Scalability and availability | Chapter 17.1 – Distributed systems |
| Microservices rejected | Chapter 17.1 and 17.1.1 |
| Space-Based rejected | Chapter 17.1 |
| Decision methodology | Chapter 15.1 |

# Final Conclusion

## Supporting text (Chapter 17.1.1)

> “Message-based interaction … does not require an immediate response. The sending system can continue processing after sending the message.”

## Supporting text (Chapter 17.1)

> “Distributed systems are scalable… capabilities can be increased by adding new resources… and can be tolerant of some hardware and software failures.”

## Conclusion

Event-Driven Architecture is selected because:

- It implements **asynchronous message-based interaction (17.1.1)**  
- It fully utilizes **scalability and fault tolerance (17.1)**  
- It reduces runtime coupling compared to synchronous models  
- It aligns with the system’s event-driven behavior  

# Summary of supporting concepts from the book

The architectural decision for EventHive is grounded in key concepts from Chapter 15.1 and Chapter 17 (especially 17.1 and 17.1.1). 

From Chapter 17.1, the book defines the fundamental properties of distributed systems:

> “In a distributed system, several processes may operate at the same time on separate computers on the network. Distributed systems are scalable in that the capabilities of the system can be increased by adding new resources to cope with new demands. The availability of several computers and the potential for replicating information means that distributed systems can be tolerant of some hardware and software failures. However, distributed systems are inherently more complex than centralized systems. This makes them more difficult to design, implement, and test.”

This passage establishes both:
- the **advantages** of distributed systems (concurrency, scalability, availability)
- and their **disadvantages** (increased complexity, failure possibilities)

These characteristics directly influenced the architectural evaluation:
- The system must scale and remain available under high load
- But complexity must be controlled

From Chapter 17.1.1, the book distinguishes two interaction models:

> “Remote procedure calls require a synchronous interaction between the client and the server. The client program waits for the called procedure to execute before continuing. This means that the overall performance of the system depends on the speed of the remote system.”

> “Message-based interaction involves the ‘sending’ computer defining information about what is required in a message, which is then sent to another computer. The receiving computer decides what to do with the message. Message-based interaction does not require an immediate response. The sending system can continue processing after sending the message.”

This distinction is central to the architectural decision:
- **Synchronous interaction (RPC)** leads to blocking, tighter coupling, and performance dependency
- **Asynchronous message-based interaction** enables decoupling, independent execution, and improved scalability

The decision to use Event-Driven Architecture follows directly from adopting the **message-based interaction model (17.1.1)**, which better supports the required system qualities.

Additionally, Chapter 17.1 emphasizes that:

> “System performance depends on network bandwidth, network load, and the speed of other computers that are part of the system. Response time depends on the overall load on the system, its architecture, and the network load.”

This highlights that **architecture and interaction style directly influence performance**, supporting the rejection of architectures that do not align with the system’s workload and communication model.

Finally, Chapter 15.1 provides the decision-making foundation:

> “Architectural patterns are used as the basis of applications. The choice of an appropriate architectural pattern depends on the system requirements, available technologies, and the expertise of the development team.”

This justifies the ADR approach itself:
- Multiple architectural patterns were considered
- The final choice was based on how well each pattern satisfies the system’s functional and non-functional requirements

## Summary

The decision to adopt Event-Driven Architecture is supported by:

- Chapter 17.1: identifying scalability, availability, and complexity trade-offs in distributed systems  
- Chapter 17.1.1: defining message-based (asynchronous) vs RPC-based (synchronous) interaction models  
- Chapter 15.1: establishing architectural pattern selection based on system requirements  

Together, these concepts justify selecting an architecture that:
- maximizes scalability and availability  
- minimizes runtime coupling  
- uses asynchronous communication to improve performance and resilience  
