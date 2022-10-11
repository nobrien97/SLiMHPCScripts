##############################################################################################################
#                                       Example sublauncher for SLiM on HPC                                  #
##############################################################################################################

#  Parallel script modified from SLiM-Extras example R script, info at
#  the SLiM-Extras repository at https://github.com/MesserLab/SLiM-Extras.

# Thanks to David Green (David.Green@uq.edu.au) for getting this to work on Nimrod

#NEED TO PROCESS 2 PARAMETERS PASSED IN  REPEAT(i.e. SEED) and LATIN SQUARE ROW NUMBER
args <- commandArgs(trailingOnly = TRUE)
if ( length(args) < 2 ) {
  cat("Need 2 command line parameters i.e. SEED LS_COMBO\n")
  q()
}

# first argument is the seed, second argument is the combo
row_seed     <- as.numeric(args[1])
row_combo    <- as.numeric(args[2])

# Environment variables

USER <- Sys.getenv('USER')


# Load LHC samples and seeds
hypercube <- read.csv(paste0("/home/",USER,"/hypercube.csv"), header = T)
seeds <- read.csv(paste0("/home/",USER,"/seeds.csv"), header = T) # .csv in a single column

#Run SLiM, defining parameter sets according to LHC samples in command line


i <- row_seed
j <- row_combo

system(sprintf("slim -s %s -d N=%i -d r=%s -d s=%s modelindex=%i /home/$USER/SLiM/Scripts/example.slim",
                as.character(seeds$Seed[i]), 
                as.integer(round(hypercube$N[j])), 
                as.character(hypercube$r[j]),
                as.character(hypercube$s[j]), 
                j, intern=T))
