
VPATH=../exec

CC=gcc
CFLAGS= -fPIC

# consider using rpcgen -N
RPCGEN= rpcgen -C

PKGNAME = padi

#R_HOME = $(top_builddir)
R_HOME = $(R)

LIBSRC = padi.c padiutil.c channel.c rpcx_xdr.c gmalloc.c
SRC = getpadi.c  putpadi.c  $(LIBSRC)

OBJS = $(SRC:.c=.o) 

OTHERSRC = rpcx_clnt.c  rpcx_svc.c  objectinfo.c simple_svc.c
OTHEROBJECTS = $(OTHERSRC:.c=.o) 

PKG_CFLAGS = -ansi -pedantic -I$(PADI_HOME)/include 
#PKG_CPPFLAGS = -DGMALLOC -trigraphs -undef
PKG_CPPFLAGS = -DGMALLOC -trigraphs
#PKG_CPPFLAGS = -DGMALLOC 

# this is not portable but may need configure to do
ifeq (${shell uname}, SunOS)
  LD_LIBS=-lm -lc -lnsl
else
  LD_LIBS= -L/usr/local/lib 
endif

all: rpcx.h padi.so ../exec/padi_simple_svc ../exec/getpwuid  ../exec/x11arima \
        ../exec/getpadi ../exec/putpadi ../exec/objectinfo



$(PKGNAME).so: $(OBJS) rpcx.h
	$(CC) -shared $(LD_LIBS) -o $(PKGNAME).so $(OBJS)
#	$(R_HOME)/bin/R CMD SHLIB -o $(PKGNAME).so $(OBJS)

../exec/padi_simple_svc:  simple_svc.c $(LIBSRC)  
	$(RM) $(notdir $@)
	$(CC) -Wall $(PKG_CFLAGS) $(PKG_CPPFLAGS) -DFS_SVC \
	    simple_svc.c $(LIBSRC)  $(LD_LIBS) -o padi_simple_svc
	mv padi_simple_svc ../exec

#needs work
fame_svc:	fame_svc.c plus fame hli
	echo not yet


../exec/getpadi: getpadi.c $(LIBSRC)
	$(CC) -Wall -DMAIN $(LD_LIBS) $< $(LIBSRC) -o $@

../exec/putpadi: putpadi.c $(LIBSRC)
	$(CC) -Wall -DMAIN $(LD_LIBS) $< $(LIBSRC) -o $@

../exec/objectinfo: objectinfo.c $(LIBSRC)
	$(CC) -Wall -DMAIN $(LD_LIBS) $< $(LIBSRC) -o $@

../exec/getpwuid: getpwuid.c
	$(CC) -Wall -DMAIN $(LD_LIBS)  $< gmalloc.c -o $@

../exec/x11arima: getpadi.c $(LIBSRC)
	$(CC) -Wall -DMAIN -DX11ARIMA $(LD_LIBS) $< $(LIBSRC) -o $@

	
rpcx_clnt.c  rpcx_svc.c  rpcx_xdr.c:	rpcx.h

rpcx.h: rpcx.x
	$(RPCGEN) $<

../exec/compare.pc: compare.pro
	fameCompile $<
	mv compare.pc ../exec

../exec/object.pc: object.pro
	fameCompile $<
	mv object.pc ../exec

../exec/target.pc: target.pro
	fameCompile $<
	mv target.pc ../exec

../exec/sys.pc:sys.pro
	fameCompile $<
	mv sys.pc ../exec

clean:
	@$(RM) getpadi putpadi objectinfo getpwuid padi_simple_svc x11arima
	@$(RM) *.so *.o 
	@$(RM) rpcx_clnt.c  rpcx.h  rpcx_svc.c  rpcx_xdr.c

distclean:	clean
	@$(RM) ../exec/getpadi ../exec/putpadi ../exec/objectinfo ../exec/getpwuid
	@$(RM) ../exec/getpwuid ../exec/padi_simple_svc ../exec/x11arima
	@$(RM) ../exec/*.pro ../exec/*server.log.*
