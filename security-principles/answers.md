# Security Principles

Identify the relevant principle(s) for each scenario and give a short reason.

## Q1.1

Scenario: Valet key opens door and ignition but not trunk or glove compartment.

Principles: F (Least privilege), G (Privilege separation)

Justification: A valet key only gives the access needed for parking, not full owner access, so I’d call that least privilege. It also keeps driving access separate from trunk and glove-box access, which limits damage if one part is exposed.

## Q1.2

Scenario: Phone liquid-damage sticker turns red permanently when wet.

Principles: D (Detect if you cannot prevent), C (Security is economics)

Justification: The sticker detects water damage instead of preventing it, because prevention is not always realistic. It is also a cheap way for the company to spot damage and reduce false warranty claims, so the economics principle applies too.

## Q1.3

Scenario: MyGov security questions with random answers, but attacker social-engineers support representative.

Principles: B (Consider human factors), H (Ensure complete mediation), A (Know your threat model)

Justification: Even strong answers can fail if support staff are tricked, so human factors matter here. Recovery requests need to be checked every time, and the threat model has to include social engineering against the help desk.

## Q1.4

Scenario: Tesla Sentry Mode records break-ins and alerts owner.

Principles: D (Detect if you cannot prevent), E (Defense in depth)

Justification: Sentry Mode is mainly about detecting break-ins and saving evidence when prevention is not enough. It also adds another layer on top of the car’s normal locks and alarm, which is a good example of defense in depth.

## Q1.5

Scenario: Laptop lock screen can be bypassed by a skilled attacker with specialized equipment.

Principles: A (Know your threat model), E (Defense in depth)

Justification: A lock screen can stop everyday users, but it is not enough against a skilled attacker with the right tools, so the threat model matters. If one control fails, other protections like disk encryption and secure boot still help, which is why defense in depth matters.
