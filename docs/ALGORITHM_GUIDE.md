# Queue Theory Algorithm: Complete Guide

## 📚 Table of Contents
1. [Algorithm Overview](#algorithm-overview)
2. [How the Algorithm Works](#how-the-algorithm-works)
3. [Mathematical Formulas Explained](#mathematical-formulas-explained)
4. [Step-by-Step Algorithm Flow](#step-by-step-algorithm-flow)
5. [Code Examples](#code-examples)
6. [Real-World Application](#real-world-application)

---

## Algorithm Overview

### What This Algorithm Does
This algorithm calculates the **optimal number of staff** needed to serve customers efficiently while keeping wait times below your target threshold.

### Key Inputs
1. **Arrival Rate (λ)**: Average customers arriving per hour
2. **Service Rate (μ)**: Average customers one employee can serve per hour
3. **Target Wait Time**: Maximum acceptable wait time (in minutes)

### Key Outputs
1. **Minimum Staff Required**: Below this, queues grow infinitely
2. **Optimal Staff Number**: Best balance of cost and wait time
3. **Performance Metrics**: Wait times, utilization rates, probabilities

---

## How the Algorithm Works

### The M/M/c Queue Model

This algorithm uses the **M/M/c queueing model**, which means:

- **First M**: Markovian (random) customer arrivals following a Poisson distribution
- **Second M**: Markovian (exponential) service times
- **c**: Multiple servers (your staff members)

### Why "Stochastic"?

**Stochastic** means random or probabilistic. Customers don't arrive at perfect intervals:
- Sometimes 5 customers arrive in 2 minutes
- Then nobody for 10 minutes
- Then 3 customers at once

The algorithm handles this randomness using probability theory.

---

## Mathematical Formulas Explained

### 1. Traffic Intensity (ρ - Rho)

```
ρ = λ / (c × μ)
```

Where:
- λ = arrival rate
- c = number of servers
- μ = service rate per server

**What it means**: How busy your system is
- ρ < 0.7: Low utilization (staff have downtime)
- ρ = 0.8: Good balance
- ρ > 0.9: Very busy (risk of long waits)
- ρ ≥ 1.0: UNSTABLE (queue grows infinitely)

**Example**:
```
40 customers/hour arriving
3 servers, each serving 20/hour
ρ = 40 / (3 × 20) = 40/60 = 0.67 (67% busy)
```

---

### 2. Minimum Servers Required

```
c_min = ⌈λ / μ⌉
```

(⌈⌉ means "round up")

**What it means**: The absolute minimum staff needed so that your service capacity exceeds arrival rate.

**Example**:
```
40 customers/hour arriving
Each server handles 20/hour
c_min = ⌈40/20⌉ = ⌈2⌉ = 2 servers minimum
```

---

### 3. Probability of Zero Customers (P₀)

This is complex but necessary for other calculations:

```
P₀ = 1 / (Σ(ρⁿ/n!) + (ρᶜ / (c! × (1 - ρ_c))))
```

Where the sum goes from n=0 to c-1, and ρ_c = λ/(c×μ)

**What it means**: The probability that your system is completely empty (no customers waiting or being served).

---

### 4. Erlang C Formula (Probability of Waiting)

```
C(c, λ/μ) = (ρᶜ × P₀) / (c! × (1 - ρ_c))
```

**What it means**: The probability that a customer arriving will have to wait (all servers are busy).

**Example result**: C = 0.35 means 35% of customers will wait

---

### 5. Average Wait Time in Queue (W_q)

```
W_q = C(c, λ/μ) / (c × μ × (1 - ρ_c))
```

**What it means**: The average time a customer spends waiting in line (not including service time).

**Example**:
```
If W_q = 0.083 hours = 5 minutes
This is the average wait time before being served
```

---

### 6. Average Number Waiting (L_q)

```
L_q = λ × W_q
```

**What it means**: The average number of customers in the queue (not being served).

**Example**:
```
40 customers/hour arrival rate
W_q = 0.083 hours (5 minutes)
L_q = 40 × 0.083 = 3.32 customers waiting on average
```

---

## Step-by-Step Algorithm Flow

```
START
  │
  ↓
1. INPUT DATA
  │ • Arrival rate (customers/hour)
  │ • Service rate (customers/hour per server)
  │ • Target wait time (minutes)
  ↓
2. CALCULATE MINIMUM SERVERS
  │ • c_min = ceiling(arrival_rate / service_rate)
  │ • This prevents infinite queue growth
  ↓
3. LOOP: Test each staffing level from c_min to max
  │
  ├─→ Calculate traffic intensity (ρ)
  │
  ├─→ Is ρ < 1? 
  │   │
  │   NO → Skip this staffing level (unstable)
  │   │
  │   YES → Continue
  │        │
  │        ↓
  │   Calculate P₀ (probability of empty system)
  │        │
  │        ↓
  │   Calculate Erlang C (probability of waiting)
  │        │
  │        ↓
  │   Calculate average wait time
  │        │
  │        ↓
  │   Does wait time meet target?
  │        │
  │        YES → Save as optimal solution
  │        NO → Continue testing
  │
  └─→ Next staffing level
  │
  ↓
4. OUTPUT RESULTS
  │ • Optimal number of servers
  │ • Expected wait times
  │ • Utilization rates
  │ • Cost implications
  ↓
END
```

---

## Code Examples

### Example 1: Basic Usage

```python
from simple_queue_calculator import calculate_optimal_staff

# Coffee shop with morning rush
result = calculate_optimal_staff(
    customers_per_hour=40,    # 40 customers arrive per hour
    service_per_hour=20,       # Each barista serves 20 per hour
    max_wait_minutes=5         # Want customers to wait < 5 minutes
)

# Output: Recommends 3 baristas
```

### Example 2: With Cost Analysis

```python
from simple_queue_calculator import calculate_optimal_staff, estimate_cost_savings

# Step 1: Find optimal staffing
result = calculate_optimal_staff(
    customers_per_hour=30,
    service_per_hour=15,
    max_wait_minutes=3
)

# Step 2: Compare with current staffing
estimate_cost_savings(
    current_staff=4,                    # You currently have 4 employees
    optimal_staff=result['num_staff'],  # Algorithm recommends 3
    hourly_wage=15,                     # $15/hour per employee
    hours_per_day=8,
    days_per_week=5
)

# Output: Shows potential savings of $1560/week by reducing 1 employee
```

### Example 3: Advanced Usage

```python
from queue_theory_staffing import QueueTheoryStaffing

# Create queue model
model = QueueTheoryStaffing(arrival_rate=50, service_rate=25)

# Get detailed analysis for different scenarios
scenarios = model.analyze_staffing_scenarios([2, 3, 4, 5])

for scenario in scenarios:
    if scenario['viable']:
        print(f"{scenario['num_servers']} servers:")
        print(f"  Wait time: {scenario['wait_time_minutes']} min")
        print(f"  Utilization: {scenario['traffic_intensity_%']}%")
```

---

## Real-World Application

### Step 1: Collect Your Data

**For 1-2 weeks, track:**

1. **Customer Arrivals**
   - Count customers each hour
   - Note peak times
   - Calculate average per hour

2. **Service Times**
   - Time how long each transaction takes
   - Calculate average service time
   - Convert to customers per hour: `60 / avg_minutes`

**Example Data Collection:**

| Time      | Customers | Total Time (min) | Avg Time |
|-----------|-----------|------------------|----------|
| 8-9 AM    | 45        | 90               | 2.0 min  |
| 9-10 AM   | 38        | 95               | 2.5 min  |
| 10-11 AM  | 22        | 66               | 3.0 min  |

From this:
- Arrival rate (8-9 AM) = 45 customers/hour
- Service rate = 60/2.0 = 30 customers/hour per employee

### Step 2: Run the Algorithm

```python
result = calculate_optimal_staff(
    customers_per_hour=45,
    service_per_hour=30,
    max_wait_minutes=5
)
```

### Step 3: Interpret Results

The algorithm tells you:

✅ **Minimum servers**: 2 (below this, line grows infinitely)
✅ **Optimal servers**: 2 (meets your 5-minute target)
✅ **Expected wait**: 2.5 minutes
✅ **Staff utilization**: 75% (good balance)

### Step 4: Make the Decision

Consider:
1. **Cost**: Can you afford the recommended staffing?
2. **Quality**: Will staff be too rushed or have downtime?
3. **Growth**: Building in buffer for future demand?
4. **Variability**: Are your arrival patterns very random?

### Step 5: Monitor and Adjust

After implementing:
- Track actual wait times weekly
- Compare to algorithm predictions
- Adjust if patterns change (seasonality, promotions, etc.)

---

## Key Insights

### Why This Algorithm Works

1. **Handles Randomness**: Uses probability theory to account for unpredictable arrivals
2. **Proven Mathematics**: Based on decades of queueing theory research
3. **Balances Tradeoffs**: Finds sweet spot between cost and service quality
4. **Predictive Power**: Forecasts performance before you staff up/down

### Limitations to Know

1. **Assumes Steady State**: Works best for consistent time periods
2. **Doesn't Handle**: 
   - Customer abandonment (people leaving if wait too long)
   - Priority queues (VIP customers)
   - Variable service times by customer type
3. **Requires Good Data**: Garbage in = garbage out

### When to Use This Algorithm

✅ **Good for:**
- Retail stores
- Bank branches
- Coffee shops
- Call centers
- Service desks
- Any customer-facing operation with queues

❌ **Not ideal for:**
- Extremely variable demand (use simulation instead)
- Very small operations (< 10 customers/day)
- When service quality trumps all cost concerns

---

## Quick Reference Cheat Sheet

| Metric | Formula | What It Tells You |
|--------|---------|-------------------|
| Min Servers | ⌈λ/μ⌉ | Minimum to prevent infinite queue |
| Utilization | λ/(c×μ) | How busy your staff is (0-100%) |
| Erlang C | Complex | % of customers who wait |
| Avg Wait | C/(c×μ×(1-ρ)) | Average minutes in queue |
| Queue Length | λ × Wait Time | Average # waiting |

**Key Rule**: Keep utilization (ρ) between 0.7 and 0.9 for best results

---

## Conclusion

This queue theory algorithm transforms guesswork into data-driven staffing decisions. By accounting for the random nature of customer arrivals, it helps you find the optimal balance between operational costs and customer satisfaction.

**Remember**: The algorithm provides recommendations, but you make the final decision based on your business context, budget constraints, and quality standards.

For questions or advanced scenarios, refer to the full code implementations provided.
