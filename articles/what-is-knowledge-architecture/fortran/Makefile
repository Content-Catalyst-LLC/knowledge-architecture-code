FC ?= gfortran
FFLAGS ?= -O2

all: taxonomy_depth_summary

taxonomy_depth_summary: taxonomy_depth_summary.f90
	$(FC) $(FFLAGS) -o taxonomy_depth_summary taxonomy_depth_summary.f90

run: taxonomy_depth_summary
	./taxonomy_depth_summary

clean:
	rm -f taxonomy_depth_summary
