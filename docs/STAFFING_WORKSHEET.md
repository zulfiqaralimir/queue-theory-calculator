# Queue Theory Staffing Worksheet
## Your Business Data Collection Template

---

## STEP 1: Identify Your Business Scenario

**What type of business/operation is this?**
(e.g., coffee shop, bank, call center, retail checkout, help desk)

_______________________________________________


**What time period are you analyzing?**
(e.g., morning rush 7-9 AM, weekday afternoons, etc.)

_______________________________________________


---

## STEP 2: Collect Arrival Data

Track customer arrivals for 1-2 weeks. Record data by hour:

### Sample Data Collection Table

| Date | Time Period | # of Customers | Notes |
|------|-------------|----------------|-------|
| 1/6  | 8-9 AM      | 42             | Monday, typical |
| 1/6  | 9-10 AM     | 35             | Slower after rush |
| 1/6  | 10-11 AM    | 18             | Very quiet |
| 1/7  | 8-9 AM      | 48             | Tuesday, busy |
| ...  | ...         | ...            | ... |

### Calculate Your Arrival Rate

Add up total customers for your target time period across all days:

- Total customers observed: _____________
- Number of hours observed: _____________
- **Average arrival rate (λ)**: _____________ customers per hour

**Formula**: Total customers ÷ Number of hours

---

## STEP 3: Measure Service Time

Time at least 20-30 customer transactions during your target period:

### Sample Service Time Recording

| Customer | Service Time (minutes) | Notes |
|----------|------------------------|-------|
| 1        | 2.5                    | Simple order |
| 2        | 4.0                    | Complex request |
| 3        | 1.5                    | Quick transaction |
| ...      | ...                    | ... |

### Calculate Your Service Rate

Sum all service times and divide by number of customers:

- Total service time: _____________ minutes
- Number of customers: _____________
- **Average service time**: _____________ minutes per customer

Now convert to service rate:

**Service rate (μ) = 60 ÷ Average service time**

- **Your service rate**: _____________ customers per hour per employee

---

## STEP 4: Define Your Target

**What is your maximum acceptable wait time?**

Target wait time: _____________ minutes

Consider:
- Industry standards (e.g., retail: 3-5 min, banks: 5-10 min)
- Customer expectations
- Competitive landscape
- Your quality standards

---

## STEP 5: Calculate Optimal Staffing

### Your Input Summary

```
Arrival Rate (λ):         _____________ customers/hour
Service Rate (μ):         _____________ customers/hour (per employee)
Target Wait Time:         _____________ minutes
```

### Run the Algorithm

Use the provided Python scripts:

```python
from simple_queue_calculator import calculate_optimal_staff

result = calculate_optimal_staff(
    customers_per_hour=_____,     # Your arrival rate
    service_per_hour=_____,        # Your service rate
    max_wait_minutes=_____         # Your target
)
```

---

## STEP 6: Record Your Results

### Algorithm Recommendations

**Minimum servers required**: _____________ employees

(Below this number, your queue will grow infinitely)

**Optimal servers recommended**: _____________ employees

### Performance Metrics

| Metric | Value |
|--------|-------|
| Expected average wait time | _______ minutes |
| Staff utilization rate | _______ % |
| Probability customer waits | _______ % |
| Avg customers in queue | _______ people |

---

## STEP 7: Cost-Benefit Analysis

### Current Situation

- Current staffing level: _____________ employees
- Hourly wage per employee: $_____________ 
- Hours per day at this level: _____________ hours
- Days per week: _____________ days

### Comparison

| Scenario | # Employees | Daily Cost | Weekly Cost | Annual Cost |
|----------|-------------|------------|-------------|-------------|
| Current  | _____       | $_____     | $_____      | $_____      |
| Optimal  | _____       | $_____     | $_____      | $_____      |
| **Difference** | **_____** | **$_____** | **$_____** | **$_____** |

### Financial Impact

If optimal < current:
- **Potential savings**: $_____________ per year
- Risk: May reduce service quality if estimates are off

If optimal > current:
- **Investment needed**: $_____________ per year
- Benefit: Improved customer satisfaction and shorter waits

If optimal = current:
- ✓ You're already well-staffed!

---

## STEP 8: Decision Making

### Factors to Consider

Check all that apply to your situation:

**Business Factors:**
- [ ] We're in a growth phase (consider staffing above optimal)
- [ ] We're cutting costs (consider minimum viable staffing)
- [ ] Customer service is our competitive advantage (staff generously)
- [ ] We operate on thin margins (optimize for cost)

**Operational Factors:**
- [ ] Arrival patterns are very unpredictable (add buffer)
- [ ] We can't easily adjust staffing mid-shift (plan conservatively)
- [ ] Part-time/on-call staff are available (can staff flexibly)
- [ ] Employees multitask other duties (may need more staff)

**Customer Factors:**
- [ ] Customers are very wait-time sensitive
- [ ] Long waits lead to lost sales
- [ ] Wait time affects repeat business
- [ ] We receive complaints about waits

### Your Decision

**Final staffing decision**: _____________ employees

**Reasoning:**
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________

---

## STEP 9: Implementation Plan

### Staffing Schedule

| Time Period | Recommended Staff | Notes |
|-------------|-------------------|-------|
| 7-8 AM      | _____            |       |
| 8-9 AM      | _____            |       |
| 9-10 AM     | _____            |       |
| ...         | ...              | ...   |

### Action Items

- [ ] Adjust employee schedules by: _____________ (date)
- [ ] Communicate changes to team by: _____________ (date)
- [ ] Begin monitoring performance on: _____________ (date)
- [ ] Review results after: _____________ (timeframe)

---

## STEP 10: Monitor and Adjust

Track actual performance weekly:

### Week 1 Results

| Metric | Target | Actual | Variance |
|--------|--------|--------|----------|
| Avg wait time | _____ min | _____ min | _____ |
| Max wait time | _____ min | _____ min | _____ |
| Staff utilization | _____ % | _____ % | _____ |
| Customer complaints | _____ | _____ | _____ |

### Week 2 Results

(Same table)

### Week 4 Results

(Same table)

### Adjustment Notes

Based on actual performance:

- [ ] Staffing is optimal - no changes needed
- [ ] Need to increase by _____ employees
- [ ] Can decrease by _____ employees
- [ ] Need to adjust for different time periods

**Adjustments made:**
_____________________________________________________________
_____________________________________________________________

---

## TIPS FOR SUCCESS

### Data Collection Tips

✓ **Be consistent**: Collect data at the same times/days
✓ **Note anomalies**: Mark unusual events (holidays, promotions, weather)
✓ **Sample size matters**: More data = better predictions
✓ **Update regularly**: Rerun analysis quarterly or when patterns change

### Common Pitfalls to Avoid

❌ **Using old data**: Customer patterns change over time
❌ **Ignoring peak variance**: Account for busy vs. slow periods
❌ **Over-optimizing**: Leave some buffer for unexpected surges
❌ **Forgetting breaks**: Staff need breaks, reducing effective capacity

### When to Rerun the Analysis

- Seasonal changes (holiday season, summer, etc.)
- After major marketing campaigns
- Business expansion or new products
- Significant customer behavior changes
- Every 3-6 months as a regular practice

---

## QUICK REFERENCE FORMULAS

**Arrival Rate (λ)**
```
λ = Total customers ÷ Total hours observed
```

**Service Rate (μ)**
```
μ = 60 ÷ Average service time in minutes
```

**Minimum Servers**
```
c_min = Round up (λ ÷ μ)
```

**Utilization**
```
ρ = λ ÷ (c × μ)
Keep between 0.70 and 0.90 for best results
```

---

## NOTES AND OBSERVATIONS

Use this space for any additional notes:

_____________________________________________________________
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________

---

**Date worksheet completed**: _____________________

**Completed by**: _____________________

**Next review date**: _____________________
