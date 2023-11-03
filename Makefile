PROJECT       = jpge
CXXFLAGS     ?= -O3 -ffast-math -fno-signed-zeros -Isrc
LDFLAGS       = -lm -s
SRCS          = src
BIN           = $(PROJECT)
LIB           = lib$(PROJECT)
PREFIX        = /usr/local
INCPREFIX     = $(PREFIX)/include/$(PROJECT)
LIBPREFIX     = $(PREFIX)/lib
MANPREFIX     = $(PREFIX)/share/man/man1
DOCPREFIX     = $(PREFIX)/share/doc/$(PROJECT)
INSTALL       = install
CHMOD         = chmod
MV            = mv
LN            = ln -fs
VER           = 0
VERREL        = 1.05
LIBNAME       = $(LIB).so.$(VER)
OBJSB         = $(SRCS)/encoder.o
OBJSL         = $(SRCS)/jpge.o $(SRCS)/jpgd.o
OBJS          = $(OBJSB) $(OBJSL)

ifneq ($(shell uname -m), i386)
        CXXFLAGS += -fPIC
endif

$(BIN): $(OBJSB) $(LIBNAME)
	$(CXX) $^ $(LDFLAGS) -o $@

$(LIBNAME): $(OBJSL)
	$(CXX) -shared -Wl,-soname,$@ $^ $(LDFLAGS) -o $@
	$(CHMOD) 644 $@
	$(MV) $@ $@.$(VERREL)
	$(LN) -s $@.$(VERREL) $@
	$(LN) -s $@ $(LIB).so

clean:
	rm $(OBJS) $(BIN) $(LIB)*

install: $(BIN)
	$(INSTALL) -d $(LIBPREFIX)
	$(INSTALL) -m 0644 $(LIBNAME).$(VERREL) $(LIBPREFIX)/$(LIBNAME).$(VERREL)
	$(LN)  $(LIBNAME).$(VERREL) $(LIBPREFIX)/$(LIBNAME)
	$(LN)  $(LIBNAME) $(LIBPREFIX)/$(LIB).so
	$(INSTALL) -d $(INCPREFIX)
	$(INSTALL) -m 0644 $(SRCS)/jpge.h $(SRCS)/jpgd.h $(INCPREFIX)
	$(INSTALL) -d $(PREFIX)/bin
	$(INSTALL) -m 0755 $(BIN) $(PREFIX)/bin/
	$(INSTALL) -d $(MANPREFIX)
	$(INSTALL) -m 0644 man/man1/jpge.1 $(MANPREFIX)
	$(INSTALL) -d $(DOCPREFIX)
	$(INSTALL) -m 0644 LICENSE README.md $(DOCPREFIX)
