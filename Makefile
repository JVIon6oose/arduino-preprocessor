.PHONY: debug install

CC = clang
CXX = clang++
CXXFLAGS += -g -w -static-libstdc++

GROUP_BEGIN = -Wl,--start-group
GROUP_END = -Wl,--end-group

LLVM_LIBS := $(shell ls $$(llvm-config --libdir)/libclang*.so | sed s/.*libclang/-lclang/ | sed s/.so$$//)

LLVM_LDFLAGS := $(shell llvm-config --libs --system-libs)
ALL_LDFLAGS := $(GROUP_BEGIN) $(LLVM_LDFLAGS) $(LLVM_LIBS) $(GROUP_END)

LLVM_CXXFLAGS := $(shell llvm-config --cxxflags)
ALL_CXXFLAGS := $(CXXFLAGS) $(LLVM_CXXFLAGS)

CXX_PREREQS = ArduinoDiagnosticConsumer.cpp CodeCompletion.cpp CommandLine.cpp IdentifiersList.cpp main.cpp

arduino-preprocessor: $(CXX_PREREQS)
	$(CXX) $(CXX_PREREQS) -o arduino-preprocessor $(ALL_CXXFLAGS) $(ALL_LDFLAGS) -v
	
install: arduino-preprocessor
	mkdir -p $(DESTDIR)$(PREFIX)/usr/bin/	
	cp $< $(DESTDIR)$(PREFIX)/usr/bin/arduino-preprocessor	

debug:
	@echo ""; echo ALL_LDFLAGS: $(ALL_LDFLAGS) 
	@echo ""; echo ALL_CXXFLAGS: $(ALL_CXXFLAGS) 
	@echo ""; echo CXX_PREREQS: $(CXX_PREREQS) 
	@echo ""; echo LLVM_LIBS: $(LLVM_LIBS)
