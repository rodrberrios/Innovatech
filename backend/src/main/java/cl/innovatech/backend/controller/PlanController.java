package cl.innovatech.backend.controller;

import cl.innovatech.backend.model.Plan;
import cl.innovatech.backend.repository.PlanRepository;
import java.util.List;
import org.springframework.web.bind.annotation.*;

/**
 *
 * @author Duoc
 */

@RestController
@RequestMapping("/api/planes")
@CrossOrigin("*")
public class PlanController {

    private final PlanRepository repository;

    public PlanController(PlanRepository repository) {
        this.repository = repository;
    }
    
    @GetMapping
    public List<Plan> getPlanes(){
        return repository.findAll();
    }
    
    
}
