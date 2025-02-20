# https://rstudio.github.io/reticulate/

install.packages("reticulate")

library(reticulate)
reticulate::virtualenv_create('r-reticulate', version='3.12')
reticulate::virtualenv_install(envname='r-reticulate', packages='git+https://github.com/InstituteforDiseaseModeling/laser-measles.git@allhands')

lm <- import("laser_measles")

parameters <- lm$generic$get_parameters(py_dict(list('seed', 'pdf'), list(20250220, TRUE)))
scenario <- lm$generic$get_scenario(parameters, parameters$verbose)
model <- lm$Model(scenario, parameters)

model$components = list(
  lm$Births,
  lm$NonDiseaseDeaths,
  lm$Susceptibility,
  lm$MaternalAntibodies,
  lm$RoutineImmunization,
  lm$Infection,
  lm$Incubation,
  lm$Transmission
)

# seed_infections_randomly(model, ninfections=100)
# Seed initial infections in Node 13 (King County) at the start of the simulation
# Pierce County is Node 18, Snohomish County is Node 14, Yakima County is 19
lm$utils$seed_infections_in_patch(model, ipatch=13, ninfections=100)

model$run()

model$visualize(pdf=parameters$pdf)
