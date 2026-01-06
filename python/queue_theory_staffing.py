"""
Queue Theory Staffing Algorithm
================================
This algorithm helps businesses determine optimal staffing levels based on
random customer arrival patterns using queue theory (M/M/c model).

M/M/c model means:
- M: Markovian (random/Poisson) arrivals
- M: Markovian (exponential) service times
- c: number of servers (staff members)
"""

import math
import random
from typing import List, Dict, Tuple


class QueueTheoryStaffing:
    """
    A class to calculate optimal staffing levels using queue theory.
    """
    
    def __init__(self, arrival_rate: float, service_rate: float):
        """
        Initialize the queue model.
        
        Args:
            arrival_rate: Average customers arriving per hour (λ - lambda)
            service_rate: Average customers one server can handle per hour (μ - mu)
        """
        self.arrival_rate = arrival_rate  # λ (lambda)
        self.service_rate = service_rate  # μ (mu)
        
    def calculate_minimum_servers(self) -> int:
        """
        Calculate the minimum number of servers needed to handle the workload.
        If arrival_rate >= service_rate * servers, the queue grows infinitely.
        
        Returns:
            Minimum number of servers needed
        """
        # We need: service_rate * num_servers > arrival_rate
        min_servers = math.ceil(self.arrival_rate / self.service_rate)
        return min_servers
    
    def calculate_traffic_intensity(self, num_servers: int) -> float:
        """
        Calculate traffic intensity (ρ - rho).
        This tells us how busy the system is.
        
        Args:
            num_servers: Number of servers/staff
            
        Returns:
            Traffic intensity (0 to 1, where 1 means fully utilized)
        """
        rho = self.arrival_rate / (num_servers * self.service_rate)
        return rho
    
    def calculate_probability_zero_customers(self, num_servers: int) -> float:
        """
        Calculate P0: Probability that no customers are in the system.
        This uses the Erlang C formula components.
        
        Args:
            num_servers: Number of servers/staff
            
        Returns:
            Probability of zero customers
        """
        rho = self.arrival_rate / self.service_rate
        
        # Calculate sum component
        sum_component = sum(
            (rho ** n) / math.factorial(n) 
            for n in range(num_servers)
        )
        
        # Calculate last term
        last_term = (rho ** num_servers) / (
            math.factorial(num_servers) * 
            (1 - self.arrival_rate / (num_servers * self.service_rate))
        )
        
        # P0 calculation
        p0 = 1 / (sum_component + last_term)
        return p0
    
    def calculate_erlang_c(self, num_servers: int) -> float:
        """
        Calculate Erlang C probability: probability that a customer has to wait.
        
        Args:
            num_servers: Number of servers/staff
            
        Returns:
            Probability of waiting (0 to 1)
        """
        rho = self.arrival_rate / self.service_rate
        traffic_intensity = self.calculate_traffic_intensity(num_servers)
        p0 = self.calculate_probability_zero_customers(num_servers)
        
        # Erlang C formula
        erlang_c = (
            (rho ** num_servers) * p0
        ) / (
            math.factorial(num_servers) * (1 - traffic_intensity)
        )
        
        return erlang_c
    
    def calculate_average_wait_time(self, num_servers: int) -> float:
        """
        Calculate average waiting time in queue (in hours).
        
        Args:
            num_servers: Number of servers/staff
            
        Returns:
            Average wait time in hours
        """
        erlang_c = self.calculate_erlang_c(num_servers)
        traffic_intensity = self.calculate_traffic_intensity(num_servers)
        
        # Average wait time formula
        wait_time = (erlang_c) / (
            num_servers * self.service_rate * (1 - traffic_intensity)
        )
        
        return wait_time
    
    def calculate_average_customers_waiting(self, num_servers: int) -> float:
        """
        Calculate average number of customers waiting in queue.
        
        Args:
            num_servers: Number of servers/staff
            
        Returns:
            Average number of customers in queue
        """
        wait_time = self.calculate_average_wait_time(num_servers)
        customers_waiting = self.arrival_rate * wait_time
        return customers_waiting
    
    def calculate_average_time_in_system(self, num_servers: int) -> float:
        """
        Calculate total time customer spends in system (waiting + being served).
        
        Args:
            num_servers: Number of servers/staff
            
        Returns:
            Average time in system (hours)
        """
        wait_time = self.calculate_average_wait_time(num_servers)
        service_time = 1 / self.service_rate
        total_time = wait_time + service_time
        return total_time
    
    def find_optimal_staffing(
        self, 
        max_wait_minutes: float = 5.0,
        max_servers: int = 20
    ) -> Dict:
        """
        Find optimal number of servers to meet wait time target.
        
        Args:
            max_wait_minutes: Maximum acceptable wait time in minutes
            max_servers: Maximum servers to consider
            
        Returns:
            Dictionary with optimal staffing recommendation
        """
        min_servers = self.calculate_minimum_servers()
        max_wait_hours = max_wait_minutes / 60
        
        results = []
        
        for num_servers in range(min_servers, max_servers + 1):
            try:
                wait_time_hours = self.calculate_average_wait_time(num_servers)
                wait_time_minutes = wait_time_hours * 60
                
                traffic_intensity = self.calculate_traffic_intensity(num_servers)
                prob_wait = self.calculate_erlang_c(num_servers)
                avg_customers_waiting = self.calculate_average_customers_waiting(num_servers)
                
                results.append({
                    'num_servers': num_servers,
                    'wait_time_minutes': wait_time_minutes,
                    'traffic_intensity': traffic_intensity,
                    'probability_of_waiting': prob_wait,
                    'avg_customers_in_queue': avg_customers_waiting,
                    'meets_target': wait_time_minutes <= max_wait_minutes
                })
                
            except (ZeroDivisionError, ValueError):
                continue
        
        # Find optimal staffing
        optimal = None
        for result in results:
            if result['meets_target']:
                optimal = result
                break
        
        return {
            'optimal_staffing': optimal,
            'all_scenarios': results,
            'min_required_servers': min_servers
        }
    
    def analyze_staffing_scenarios(self, server_range: List[int]) -> List[Dict]:
        """
        Analyze multiple staffing scenarios for comparison.
        
        Args:
            server_range: List of server counts to analyze
            
        Returns:
            List of analysis results for each scenario
        """
        results = []
        min_servers = self.calculate_minimum_servers()
        
        for num_servers in server_range:
            if num_servers < min_servers:
                results.append({
                    'num_servers': num_servers,
                    'status': 'UNSTABLE - Queue grows infinitely',
                    'viable': False
                })
                continue
            
            try:
                wait_time = self.calculate_average_wait_time(num_servers)
                wait_minutes = wait_time * 60
                
                traffic_intensity = self.calculate_traffic_intensity(num_servers)
                prob_wait = self.calculate_erlang_c(num_servers)
                avg_waiting = self.calculate_average_customers_waiting(num_servers)
                time_in_system = self.calculate_average_time_in_system(num_servers)
                
                results.append({
                    'num_servers': num_servers,
                    'status': 'STABLE',
                    'viable': True,
                    'wait_time_minutes': round(wait_minutes, 2),
                    'total_time_minutes': round(time_in_system * 60, 2),
                    'traffic_intensity_%': round(traffic_intensity * 100, 1),
                    'probability_of_waiting_%': round(prob_wait * 100, 1),
                    'avg_customers_in_queue': round(avg_waiting, 2)
                })
            except Exception as e:
                results.append({
                    'num_servers': num_servers,
                    'status': f'ERROR: {str(e)}',
                    'viable': False
                })
        
        return results


def simulate_customer_arrivals(
    arrival_rate: float, 
    service_rate: float, 
    num_servers: int, 
    simulation_hours: int = 8
) -> Dict:
    """
    Simulate actual customer arrivals and service using random events.
    This demonstrates the 'stochastic' (random) nature of queue theory.
    
    Args:
        arrival_rate: Customers per hour
        service_rate: Customers one server can handle per hour
        num_servers: Number of servers
        simulation_hours: Hours to simulate
        
    Returns:
        Dictionary with simulation results
    """
    # Convert rates to time between events (in minutes)
    avg_time_between_arrivals = 60 / arrival_rate
    avg_service_time = 60 / service_rate
    
    current_time = 0
    max_time = simulation_hours * 60  # Convert to minutes
    
    queue = []  # Waiting customers
    servers_busy_until = [0] * num_servers  # When each server becomes free
    
    wait_times = []
    total_customers = 0
    
    while current_time < max_time:
        # Generate random time until next arrival (exponential distribution)
        time_to_next_arrival = random.expovariate(1 / avg_time_between_arrivals)
        current_time += time_to_next_arrival
        
        if current_time >= max_time:
            break
        
        total_customers += 1
        arrival_time = current_time
        
        # Find an available server
        available_server = None
        earliest_free_time = float('inf')
        
        for i, free_time in enumerate(servers_busy_until):
            if free_time <= current_time:
                available_server = i
                break
            elif free_time < earliest_free_time:
                earliest_free_time = free_time
                available_server = i
        
        # Calculate wait time
        if servers_busy_until[available_server] <= current_time:
            wait_time = 0
            service_start = current_time
        else:
            wait_time = servers_busy_until[available_server] - current_time
            service_start = servers_busy_until[available_server]
        
        wait_times.append(wait_time)
        
        # Generate random service time
        service_time = random.expovariate(1 / avg_service_time)
        servers_busy_until[available_server] = service_start + service_time
    
    avg_wait = sum(wait_times) / len(wait_times) if wait_times else 0
    max_wait = max(wait_times) if wait_times else 0
    customers_who_waited = sum(1 for w in wait_times if w > 0)
    
    return {
        'total_customers': total_customers,
        'avg_wait_time_minutes': round(avg_wait, 2),
        'max_wait_time_minutes': round(max_wait, 2),
        'percent_who_waited': round(100 * customers_who_waited / total_customers, 1),
        'all_wait_times': wait_times
    }


# Example usage and demonstrations
if __name__ == "__main__":
    print("=" * 70)
    print("QUEUE THEORY STAFFING OPTIMIZATION ALGORITHM")
    print("=" * 70)
    
    # Example 1: Coffee Shop
    print("\n📊 EXAMPLE 1: Coffee Shop Morning Rush")
    print("-" * 70)
    print("Scenario: 40 customers/hour arrive, each barista serves 20 customers/hour")
    
    coffee_shop = QueueTheoryStaffing(arrival_rate=40, service_rate=20)
    
    print(f"\nMinimum servers needed: {coffee_shop.calculate_minimum_servers()}")
    
    # Analyze different staffing levels
    print("\nAnalyzing different staffing scenarios:")
    scenarios = coffee_shop.analyze_staffing_scenarios([1, 2, 3, 4])
    
    for scenario in scenarios:
        print(f"\n  {scenario['num_servers']} Barista(s): {scenario['status']}")
        if scenario['viable']:
            print(f"    • Average wait time: {scenario['wait_time_minutes']} minutes")
            print(f"    • Staff utilization: {scenario['traffic_intensity_%']}%")
            print(f"    • Probability customer waits: {scenario['probability_of_waiting_%']}%")
            print(f"    • Average customers in line: {scenario['avg_customers_in_queue']}")
    
    # Find optimal staffing for 5-minute wait target
    print("\n🎯 Finding optimal staffing for max 5-minute wait time:")
    optimal = coffee_shop.find_optimal_staffing(max_wait_minutes=5)
    
    if optimal['optimal_staffing']:
        opt = optimal['optimal_staffing']
        print(f"\n  ✓ RECOMMENDATION: Hire {opt['num_servers']} baristas")
        print(f"    • Expected wait time: {opt['wait_time_minutes']:.2f} minutes")
        print(f"    • Staff utilization: {opt['traffic_intensity']*100:.1f}%")
    
    # Example 2: Bank Tellers
    print("\n\n📊 EXAMPLE 2: Bank on Friday Afternoon")
    print("-" * 70)
    print("Scenario: 25 customers/hour arrive, each teller serves 12 customers/hour")
    
    bank = QueueTheoryStaffing(arrival_rate=25, service_rate=12)
    
    optimal_bank = bank.find_optimal_staffing(max_wait_minutes=5)
    
    if optimal_bank['optimal_staffing']:
        opt = optimal_bank['optimal_staffing']
        print(f"\n  ✓ RECOMMENDATION: {opt['num_servers']} tellers needed")
        print(f"    • Expected wait time: {opt['wait_time_minutes']:.2f} minutes")
        print(f"    • Probability of waiting: {opt['probability_of_waiting']*100:.1f}%")
    
    # Example 3: Simulation showing randomness
    print("\n\n📊 EXAMPLE 3: Simulation (Showing the 'Stochastic' Nature)")
    print("-" * 70)
    print("Running 8-hour simulation with random customer arrivals...")
    print("(This demonstrates why we call it a 'stochastic' model)")
    
    sim_results = simulate_customer_arrivals(
        arrival_rate=40, 
        service_rate=20, 
        num_servers=3,
        simulation_hours=8
    )
    
    print(f"\n  Simulation Results:")
    print(f"    • Total customers served: {sim_results['total_customers']}")
    print(f"    • Average wait time: {sim_results['avg_wait_time_minutes']} minutes")
    print(f"    • Maximum wait time: {sim_results['max_wait_time_minutes']} minutes")
    print(f"    • Percent who waited: {sim_results['percent_who_waited']}%")
    
    print("\n" + "=" * 70)
    print("💡 KEY INSIGHT: Even with optimal staffing, some randomness exists")
    print("   in wait times due to the unpredictable nature of arrivals!")
    print("=" * 70)
