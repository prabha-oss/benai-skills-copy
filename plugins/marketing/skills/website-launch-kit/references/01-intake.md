# Phase 1: Business Intake (Deep Understanding)

This phase is critical. You must deeply understand the user's business before suggesting any design or copy.

**ONE QUESTION AT A TIME RULE:** Never ask multiple questions in one message. Wait for the user's answer before proceeding.

**TOOL USAGE:** Every question must use the `AskUserQuestion` tool to present options in a modal UI.

---

## Question Bank & Logic

Follow this flow. Adapt based on answers.

### 1. Business Foundation

**Q1: Business Type**
```
AskUserQuestion(
  question: "Is this for a product or a service?",
  options: [
    { label: "Product", description: "SaaS, app, digital or physical product" },
    { label: "Service", description: "Agency, consulting, freelance, coaching" }
  ]
)
```

**Q2: Service Type** *(only if Service selected)*
```
AskUserQuestion(
  question: "What type of service do you provide?",
  options: [
    { label: "Consulting", description: "Strategy and expert advice" },
    { label: "Agency / Done-for-you", description: "You deliver finished work" },
    { label: "Coaching / Training", description: "You teach or guide people" },
    { label: "Freelance / Creative", description: "Design, writing, dev, etc." }
  ]
)
```

**Q2 alt: Product Type** *(only if Product selected)*
```
AskUserQuestion(
  question: "What type of product is this?",
  options: [
    { label: "SaaS / Software", description: "Online tool or app" },
    { label: "Digital Product", description: "Course, template, ebook" },
    { label: "Physical Product", description: "Tangible item you ship" },
    { label: "Membership / Community", description: "Recurring access" }
  ]
)
```

**Q3: Business Name**
```
AskUserQuestion(
  question: "What's the name of your business?",
  options: [
    { label: "I have a name", description: "Type it in the text field" },
    { label: "I need help naming it", description: "I'll suggest options later" }
  ]
)
```

**Q4: Main Offering**
```
AskUserQuestion(
  question: "What's the main thing your customers get from you?",
  options: [
    { label: "I'll describe it", description: "Type your answer" },
    { label: "Help me articulate it", description: "I'll ask follow-up questions" }
  ]
)
```

### 2. Target Audience

**Q5: Ideal Customer**
```
AskUserQuestion(
  question: "Do you have a clear picture of your ideal customer?",
  options: [
    { label: "Yes, I know exactly who", description: "I'll describe them" },
    { label: "Somewhat, but not specific", description: "Help me define them" },
    { label: "Not really", description: "We'll figure it out together" }
  ]
)
```

**Q6: Customer Role**
```
AskUserQuestion(
  question: "What's your ideal customer's role?",
  options: [
    { label: "Founder / CEO", description: "Business owners and decision makers" },
    { label: "Manager / Director", description: "Mid-level decision makers" },
    { label: "Individual / Consumer", description: "B2C customers" },
    { label: "Other", description: "Describe in text field" }
  ]
)
```

**Q7: Company Size**
```
AskUserQuestion(
  question: "What size company do they work at?",
  options: [
    { label: "Solo / Freelancer", description: "Just themselves" },
    { label: "Small team (2-10)", description: "Early stage" },
    { label: "Growing (11-50)", description: "Scaling up" },
    { label: "Larger (50+)", description: "Established company" }
  ]
)
```

**Q8: Bad Fit** *(optional)*
```
AskUserQuestion(
  question: "Do you know who you'd turn away?",
  options: [
    { label: "Yes, I know who's not a fit", description: "I'll ask you to describe" },
    { label: "Not really", description: "We'll skip this" }
  ]
)
```

### 3. The Problem

**Q9: Trigger Moment**
```
AskUserQuestion(
  question: "Do you know what makes customers start looking for your solution?",
  options: [
    { label: "Yes, there's a specific moment", description: "I'll describe the trigger" },
    { label: "It varies", description: "I'll describe a few scenarios" },
    { label: "Not sure", description: "We'll explore together" }
  ]
)
```

**Q10: Problem #1**
```
AskUserQuestion(
  question: "Can you name the #1 problem your customers want solved?",
  options: [
    { label: "Yes, I can describe it", description: "Type it" },
    { label: "I have a few problems", description: "We'll go through them one by one" },
    { label: "Need help articulating", description: "I'll ask questions to uncover it" }
  ]
)
```

**Q11: Problem Impact**
```
AskUserQuestion(
  question: "How does this problem affect them most?",
  options: [
    { label: "Costs them money", description: "Financial impact" },
    { label: "Wastes their time", description: "Efficiency impact" },
    { label: "Causes stress/frustration", description: "Emotional impact" },
    { label: "All of the above", description: "Multiple impacts" }
  ]
)
```

### 4. Your Solution

**Q12: Success Outcome**
```
AskUserQuestion(
  question: "What does success look like after working with you?",
  options: [
    { label: "I can describe the transformation", description: "Type it" },
    { label: "Help me articulate it", description: "I'll ask specific questions" }
  ]
)
```

**Q13: Timeline**
```
AskUserQuestion(
  question: "How quickly can customers expect results?",
  options: [
    { label: "Within days", description: "Very fast turnaround" },
    { label: "Within 2-4 weeks", description: "Reasonable timeframe" },
    { label: "Within 1-3 months", description: "Longer engagement" },
    { label: "It varies significantly", description: "Depends on scope" }
  ]
)
```

**Q14: Process**
```
AskUserQuestion(
  question: "Do you have a defined process for how you work?",
  options: [
    { label: "Yes, I have clear steps", description: "I'll list them" },
    { label: "Somewhat defined", description: "We can refine it" },
    { label: "Not really", description: "I can help create one or skip" }
  ]
)
```

### 5. Why You

**Q15: Competitive Awareness**
```
AskUserQuestion(
  question: "Do you know what customers have tried before finding you?",
  options: [
    { label: "Yes, I know their failed attempts", description: "Describe them" },
    { label: "Not specifically", description: "We'll skip this" }
  ]
)
```

**Q16: Differentiator**
```
AskUserQuestion(
  question: "What's the #1 reason someone should choose you?",
  options: [
    { label: "I can explain it", description: "Type your answer" },
    { label: "Help me figure it out", description: "I'll ask comparison questions" }
  ]
)
```

### 6. Social Proof

**Q17: Social Proof**
```
AskUserQuestion(
  question: "What kind of proof do you have that this works?",
  options: [
    { label: "Testimonials or reviews", description: "I'll ask for 2-3 best ones" },
    { label: "Results with specific numbers", description: "I'll ask for the stats" },
    { label: "Client logos or case studies", description: "I'll ask which names" },
    { label: "None yet", description: "We'll work without this section" }
  ]
)
```

### 7. Objections

**Q18: Objections**
```
AskUserQuestion(
  question: "Do you know why people hesitate to buy?",
  options: [
    { label: "Yes, I hear common objections", description: "I'll ask you to describe them" },
    { label: "Not specifically", description: "We'll skip the FAQ section" }
  ]
)
```

**Q19: Scope Clarity** *(if they have objections)*
```
AskUserQuestion(
  question: "Is it clear what's included vs not included?",
  options: [
    { label: "Yes, I can list both", description: "I'll ask separately" },
    { label: "Included is clear, exclusions not", description: "I'll help define" },
    { label: "Needs work", description: "We'll figure it out" }
  ]
)
```

### 8. Call to Action

**Q20: CTA Action**
```
AskUserQuestion(
  question: "What's the ONE action visitors should take?",
  options: [
    { label: "Book a call", description: "Schedule a meeting" },
    { label: "Sign up", description: "Create an account or free trial" },
    { label: "Buy directly", description: "Make a purchase" },
    { label: "Request a quote", description: "Get pricing" }
  ]
)
```

**Q21: Form Fields**
```
AskUserQuestion(
  question: "How much info do you need to collect?",
  options: [
    { label: "Just name and email", description: "Minimal friction" },
    { label: "Add company name", description: "B2B qualification" },
    { label: "Add phone number", description: "Direct contact" },
    { label: "Custom fields needed", description: "I'll ask what" }
  ]
)
```

**Q22: Form Destination**
```
AskUserQuestion(
  question: "Where should form submissions go?",
  options: [
    { label: "Email me directly", description: "To your inbox" },
    { label: "My CRM", description: "HubSpot, Salesforce, etc." },
    { label: "Calendly or booking link", description: "Direct scheduling" },
    { label: "I'm not sure", description: "We'll figure it out" }
  ]
)
```

---

## Output Summary

After Q22, present a summary of all answers grouped by category, then proceed to Phase 2 (Design Inspiration).
