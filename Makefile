PNAME         = jpge
CXXFLAGS     ?= -O3 -ffast-math -fno-signed-zeros
LDFLAGS       = -s
SRCS          = src
OBJSB         = $(SRCS)/encoder.o
OBJSL         = $(SRCS)/jpge.o $(SRCS)/jpgd.o
OBJS          = $(OBJSB) $(OBJSL)
BIN           = $(PNAME)
LIB           = lib$(PNAME)
PREFIX        = /usr/local
INCPREFIX     = $(PREFIX)/include/$(PNAME)
LIBPREFIX     = $(PREFIX)/lib
MANPREFIX     = $(PREFIX)/share/man/man1
DOCPREFIX     = $(PREFIX)/share/doc/$(PNAME)
INSTALL       = install
LN            = ln -fs
VER           = 0
VERREL        = 1.04
LIBNAME       = $(LIB).so.$(VER)

$(BIN): $(OBJSB) $(LIBNAME)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ $^

$(LIBNAME): $(OBJSL)
	$(CXX) -shared -Wl,-soname,$@ $(CXXFLAGS) $(LDFLAGS) -o $@ $^
	chmod 644 $@
	mv $@ $@.$(VERREL)
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
	$(INSTALL) -m 0644 $(SRCS)/*.h $(INCPREFIX)
	$(INSTALL) -d $(PREFIX)/bin
	$(INSTALL) -m 0755 $(BIN) $(PREFIX)/bin/
	$(INSTALL) -d $(MANPREFIX)
	$(INSTALL) -m 0644 man/man1/*.1 $(MANPREFIX)
	$(INSTALL) -d $(DOCPREFIX)
	$(INSTALL) -m 0644 LICENSE README.md $(DOCPREFIX)
