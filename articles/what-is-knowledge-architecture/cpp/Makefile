CXX ?= c++
CXXFLAGS ?= -O2 -std=c++17

all: knowledge_architecture_metrics

knowledge_architecture_metrics: knowledge_architecture_metrics.cpp
	$(CXX) $(CXXFLAGS) -o knowledge_architecture_metrics knowledge_architecture_metrics.cpp

run: knowledge_architecture_metrics
	./knowledge_architecture_metrics

clean:
	rm -f knowledge_architecture_metrics
