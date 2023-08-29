package org.confluent.customeronboarding.repository;

import org.confluent.customeronboarding.entity.customer;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CustomerRepository extends JpaRepository<customer, String> {
    customer findByEmailId(String emailId);
}
