"""
SIMPLE QUEUE THEORY CALCULATOR
================================
Easy-to-use version for beginners

This calculates optimal staffing based on:
1. How many customers arrive per hour (on average)
2. How many customers one employee can serve per hour
3. Your target maximum wait time
"""

import math


def calculate_optimal_staff(customers_per_hour, service_per_hour, max_wait_minutes=5):
    """
    Simple function to calculate optimal staffing.
    
    Args:
        customers_per_hour: How many customers arrive per hour (average)
        service_per_hour: How many customers ONE employee can serve per hour
        max_wait_minutes: Maximum acceptable wait time in minutes
        
    Returns:
        Dictionary with staffing recommendation
    """
    
    # Step 1: Calculate minimum staff needed
    # (You need enough staff so they can serve faster than customers arrive)
    min_staff = math.ceil(customers_per_hour / service_per_hour)
    
    print(f"\n{'='*60}")
    print(f"QUEUE THEORY STAFFING CALCULATOR")
    print(f"{'='*60}")
    print(f"\n📊 Your Business Metrics:")
    print(f"   • Customers arriving: {customers_per_hour} per hour")
    print(f"   • One employee serves: {service_per_hour} per hour")
    print(f"   • Target wait time: {max_wait_minutes} minutes or less")
    
    print(f"\n{'='*60}")
    print(f"ANALYSIS")
    print(f"{'='*60}")
    
    print(f"\n✓ Minimum staff needed: {min_staff}")
    print(f"  (Less than this and your line grows forever!)")
    
    # Step 2: Test different staffing levels
    print(f"\n📈 Testing different staffing levels:\n")
    
    best_staff = None
    
    for num_staff in range(min_staff, min_staff + 10):
        # Calculate how busy staff will be (utilization)
        utilization = customers_per_hour / (num_staff * service_per_hour)
        
        # Skip if utilization is too high (unstable)
        if utilization >= 1:
            continue
        
        # Calculate probability customer has to wait (Erlang C formula - simplified)
        try:
            # This is a simplified approximation
            rho = customers_per_hour / service_per_hour
            
            # Sum component for Erlang C
            sum_part = sum((rho ** n) / math.factorial(n) for n in range(num_staff))
            
            # Last term
            last_term = (rho ** num_staff) / (
                math.factorial(num_staff) * (1 - utilization)
            )
            
            # P0 (probability of zero customers)
            p0 = 1 / (sum_part + last_term)
            
            # Erlang C (probability of waiting)
            erlang_c = (rho ** num_staff * p0) / (
                math.factorial(num_staff) * (1 - utilization)
            )
            
            # Average wait time in hours
            wait_time_hours = erlang_c / (
                num_staff * service_per_hour * (1 - utilization)
            )
            
            # Convert to minutes
            wait_time_minutes = wait_time_hours * 60
            
            # Display results
            status = "✓ MEETS TARGET" if wait_time_minutes <= max_wait_minutes else "✗ Too slow"
            
            print(f"  {num_staff} employees: {wait_time_minutes:.2f} min wait | "
                  f"{utilization*100:.0f}% busy | {status}")
            
            # Save the first one that meets target
            if best_staff is None and wait_time_minutes <= max_wait_minutes:
                best_staff = {
                    'num_staff': num_staff,
                    'wait_time': wait_time_minutes,
                    'utilization': utilization * 100,
                    'probability_wait': erlang_c * 100
                }
        
        except (ValueError, ZeroDivisionError):
            continue
    
    # Step 3: Recommendation
    print(f"\n{'='*60}")
    print(f"RECOMMENDATION")
    print(f"{'='*60}")
    
    if best_staff:
        print(f"\n🎯 Optimal Staffing: {best_staff['num_staff']} employees")
        print(f"\n   Expected Performance:")
        print(f"   • Average wait time: {best_staff['wait_time']:.2f} minutes")
        print(f"   • Staff utilization: {best_staff['utilization']:.1f}%")
        print(f"   • Chance customer waits: {best_staff['probability_wait']:.1f}%")
        
        print(f"\n💡 What this means:")
        if best_staff['utilization'] < 70:
            print(f"   Your staff will have some idle time (good for quality)")
        elif best_staff['utilization'] < 85:
            print(f"   Your staff will be efficiently utilized (balanced)")
        else:
            print(f"   Your staff will be very busy (may be stressful)")
    else:
        print(f"\n⚠️  Could not find optimal staffing within reasonable range")
        print(f"   Consider: {min_staff + 2} employees as a starting point")
    
    print(f"\n{'='*60}\n")
    
    return best_staff


def estimate_cost_savings(
    current_staff, 
    optimal_staff, 
    hourly_wage, 
    hours_per_day, 
    days_per_week=5
):
    """
    Calculate potential cost savings or customer satisfaction improvement.
    
    Args:
        current_staff: Current number of employees
        optimal_staff: Recommended number of employees
        hourly_wage: Cost per employee per hour
        hours_per_day: Hours this staffing level applies
        days_per_week: Working days per week
        
    Returns:
        Cost impact analysis
    """
    staff_difference = current_staff - optimal_staff
    
    daily_cost_diff = staff_difference * hourly_wage * hours_per_day
    weekly_cost_diff = daily_cost_diff * days_per_week
    annual_cost_diff = weekly_cost_diff * 52
    
    print(f"{'='*60}")
    print(f"COST IMPACT ANALYSIS")
    print(f"{'='*60}")
    print(f"\nCurrent staffing: {current_staff} employees")
    print(f"Optimal staffing: {optimal_staff} employees")
    print(f"Difference: {staff_difference} employees")
    
    if staff_difference > 0:
        print(f"\n💰 POTENTIAL SAVINGS (by reducing staff):")
        print(f"   • Per day: ${daily_cost_diff:,.2f}")
        print(f"   • Per week: ${weekly_cost_diff:,.2f}")
        print(f"   • Per year: ${annual_cost_diff:,.2f}")
        print(f"\n⚠️  Note: Ensure customer satisfaction remains acceptable!")
    elif staff_difference < 0:
        print(f"\n📈 INVESTMENT NEEDED (to improve service):")
        print(f"   • Additional cost per day: ${abs(daily_cost_diff):,.2f}")
        print(f"   • Additional cost per week: ${abs(weekly_cost_diff):,.2f}")
        print(f"   • Additional cost per year: ${abs(annual_cost_diff):,.2f}")
        print(f"\n✓ Benefit: Reduced wait times and happier customers!")
    else:
        print(f"\n✓ You're already optimally staffed! Nice job!")
    
    print(f"{'='*60}\n")
    
    return {
        'staff_difference': staff_difference,
        'annual_impact': annual_cost_diff
    }


# ============================================================================
# EXAMPLE SCENARIOS
# ============================================================================

if __name__ == "__main__":
    
    print("\n" + "="*60)
    print("SCENARIO 1: Coffee Shop")
    print("="*60)
    result1 = calculate_optimal_staff(
        customers_per_hour=40,
        service_per_hour=20,
        max_wait_minutes=5
    )
    
    if result1:
        print("\n💭 Thinking about cost?")
        estimate_cost_savings(
            current_staff=4,  # You currently have 4 baristas
            optimal_staff=result1['num_staff'],
            hourly_wage=15,
            hours_per_day=2,  # Peak hours only
            days_per_week=7
        )
    
    
    print("\n" + "="*60)
    print("SCENARIO 2: Customer Service Desk")
    print("="*60)
    result2 = calculate_optimal_staff(
        customers_per_hour=30,
        service_per_hour=15,
        max_wait_minutes=3
    )
    
    
    print("\n" + "="*60)
    print("SCENARIO 3: Bank Tellers")
    print("="*60)
    result3 = calculate_optimal_staff(
        customers_per_hour=25,
        service_per_hour=12,
        max_wait_minutes=5
    )
    
    
    # Instructions for using with your own data
    print("\n" + "="*60)
    print("HOW TO USE THIS FOR YOUR BUSINESS")
    print("="*60)
    print("""
To use this algorithm for your business:

1. COLLECT DATA (for 1-2 weeks):
   • Count customers arriving each hour
   • Time how long it takes to serve each customer
   • Note your busiest periods

2. CALCULATE YOUR RATES:
   • Arrival rate = average customers per hour
   • Service rate = 60 / average_service_time_in_minutes
   
   Example: If service takes 4 minutes on average:
   Service rate = 60 / 4 = 15 customers per hour

3. RUN THE ALGORITHM:
   Just call: calculate_optimal_staff(
       customers_per_hour=YOUR_ARRIVAL_RATE,
       service_per_hour=YOUR_SERVICE_RATE,
       max_wait_minutes=YOUR_TARGET
   )

4. IMPLEMENT AND MONITOR:
   • Start with the recommended staffing
   • Track actual wait times
   • Adjust if needed based on real results
    """)
    
    print("="*60)
    print("Need help? The algorithm shows you:")
    print("  ✓ Minimum staff to avoid infinite queues")
    print("  ✓ Optimal staff for your wait time target")
    print("  ✓ Expected utilization rates")
    print("  ✓ Cost savings opportunities")
    print("="*60 + "\n")
