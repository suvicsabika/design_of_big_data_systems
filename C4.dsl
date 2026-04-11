workspace "EvenHive" "Digital Event Organizer and Ticket Selling Platform" {

    !identifiers hierarchical

    model {
        u = person "User"
        o = person "Organizer"

        ss = softwareSystem "EventHive" {

            em = container "Event Manager" {
                tags "Create event" "Publish Event"
            }

            tm = container "Ticket Manager" {
                tags "Sell online tickets" "Dynamic pricing"

                bc = component "Booking Controller" {
                    description "Handles ticket booking requests"
                }

                ps = component "Pricing Service" {
                    description "Applies dynamic pricing strategies"
                }

                is = component "Inventory Service" {
                    description "Manages ticket availability and seat allocation"
                }

                ts = component "Ticket Service" {
                    description "Generates and manages tickets"
                }

                pi = component "Payment Integration" {
                    description "Communicates with Payment container"
                }

                nt = component "Notification Service" {
                    description "Triggers SMS confirmations"
                }
            }

            ln = container "Login" {
                tags "QR/NFC validation"
            }

            st = container "Seating" {
                tags "Manage capacity" "Manage seating"
            }

            mt = container "Monitoring" {
                tags "Real-time visits"
            }

            mk = container "Marketing" {
                tags "Campaings" "Recommendations"
            }

            an = container "Analytics" {
                tags "Dashboard for Organizers" "Core analytics"
            }

            pm = container "Payment" {
                tags "Payments services"
            }

            sm = container "SMS" {
                tags "SMS service"
            }
        }

        // Container-level relationships
        o -> ss.em "Managing events"
        o -> ss.tm "Managing tickets"
        ss.tm -> u "Selling tickets"
        ss.tm -> ss.st "Syncing seats"
        u -> ss.ln "Login"
        o -> ss.ln "Login"
        o -> ss.st "Managing seating"
        o -> ss.mt "Real-time monitoring"
        o -> ss.mk "Marketing"
        ss.mk -> u "Recommending"
        ss.an -> o "Analyze and create dashboards"
        ss.tm -> ss.pm "Enabling payment"
        ss.sm -> u "Providing communication"
        ss.sm -> o "Providing communication"

        // Component-level relationships
        u -> ss.tm.bc "Books tickets"
        o -> ss.tm.bc "Manages ticket sales"

        ss.tm.bc -> ss.tm.ps "Requests price calculation"
        ss.tm.bc -> ss.tm.is "Checks availability"
        ss.tm.bc -> ss.tm.ts "Creates ticket"
        ss.tm.bc -> ss.tm.pi "Initiates payment"

        ss.tm.pi -> ss.pm "Processes payment"

        ss.tm.is -> ss.st "Sync seat availability"

        ss.tm.ts -> ss.tm.nt "Triggers notification"
        ss.tm.nt -> ss.sm "Send SMS confirmation"
    }

    views {
        systemContext ss "Context" {
            include *
            autolayout lr
        }

        container ss "Container" {
            include *
            autolayout lr
        }

        component ss.tm "TicketManagerComponents" {
            include *
            autolayout lr
        }

        styles {
            element "Element" {
                color #DC143C
                stroke #DC143C
                strokeWidth 7
                shape roundedbox
            }
            element "Person" {
                shape person
            }
            element "SMS" {
                shape cylinder
            }
            element "Boundary" {
                strokeWidth 5
            }
            relationship "Relationship" {
                thickness 4
            }
        }
    }

    configuration {
        scope softwaresystem
    }

}