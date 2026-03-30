package cl.innovatech.backend.repository;

import cl.innovatech.backend.model.Plan;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 *
 * @author Duoc
 */
public interface PlanRepository extends JpaRepository<Plan, Long>{
    
}
