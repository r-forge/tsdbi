# It might be possible to incorporate this into Makevars, so normal R build
#  is used for compiling the .so and pieces for it. In theory that might be
#  more portable. This would require putting $(SHLIB) in the default target
#  However, R then tries to compile fame_svc.c, 
#  which fails unless fame headers are available, and there are
#  several problems with rpcx.x generated code. 
#  This may require considerable work, so leave Makefile in place, 

# R CMD SHLIB padi.c getpadi.c putpadi.c padiutil.c channel.c rpcx_xdr.c gmalloc.c
# WALL is good for testing, but rpcgen puts some unused variables in
#   the code it generates, and those cause lots of warning messages.
#WALL=-Wall

#VPATH=../exec

include  Makevars

# consider using rpcgen -N
RPCGEN= rpcgen -C

PKGNAME = padi

LIBSRC = padi.c padiutil.c channel.c rpcx_xdr.c gmalloc.c
SRC = $(LIBSRC) getpadi.c  putpadi.c 

OBJS = $(SRC:.c=.o) 

OTHERSRC = rpcx_clnt.c  rpcx_svc.c  objectinfo.c simple_svc.c
OTHEROBJECTS = $(OTHERSRC:.c=.o) 
     
all: rpcx.h padi.so ../exec/padi_simple_svc ../exec/getpwuid  ../exec/x11arima \
        ../exec/getpadi ../exec/putpadi ../exec/objectinfo

$(PKGNAME).so: $(SRC) rpcx.h
	$(R_HOME)/bin/R CMD SHLIB  $(SRC)

#$(PKGNAME).so: $(OBJS) rpcx.h
#	$(R_HOME)/bin/R CMD SHLIB  $(OBJS)

#R_INCLUDE_DIR=$(R_HOME)lib/R/include $(R_HOME)/bin/R CMD SHLIB  $(OBJS)
#$(R_HOME)/bin/R CMD SHLIB  $(PKG_CFLAGS) $(OBJS)
#R CMD SHLIB  $(OBJS)
#gcc -fPIC   -c -o padi.o padi.c


#$(PKGNAME).so: $(OBJS) rpcx.h
#	$(CC) -shared $(LD_LIBS) -o $(PKGNAME).so $(OBJS)


../exec/padi_simple_svc:  simple_svc.c $(LIBSRC)  
	$(RM) $(notdir $@)
	$(CC) $(WALL) $(PKG_CFLAGS) $(PKG_CPPFLAGS) -DFS_SVC \
	    simple_svc.c $(LIBSRC)  $(LD_LIBS) -o padi_simple_svc
	mv padi_simple_svc ../exec

#needs work
#fame_svc:	fame_svc.c plus fame hli
#	echo not yet

../exec/getpadi: getpadi.c $(LIBSRC) rpcx.h
	$(CC) $(WALL) $(PKG_CFLAGS) $(PKG_CPPFLAGS) -DMAIN $(LD_LIBS) $< $(LIBSRC) -o $@

../exec/putpadi: putpadi.c $(LIBSRC) rpcx.h
	$(CC) $(WALL) $(PKG_CFLAGS) $(PKG_CPPFLAGS) -DMAIN $(LD_LIBS) $< $(LIBSRC) -o $@

../exec/objectinfo: objectinfo.c $(LIBSRC) rpcx.h
	$(CC) $(WALL) $(PKG_CFLAGS) $(PKG_CPPFLAGS) -DMAIN $(LD_LIBS) $< $(LIBSRC) -o $@

../exec/getpwuid: getpwuid.c
	$(CC) $(WALL) $(PKG_CFLAGS) $(PKG_CPPFLAGS) -DMAIN $(LD_LIBS)  $< gmalloc.c -o $@

../exec/x11arima: getpadi.c $(LIBSRC) rpcx.h
	$(CC) $(WALL) $(PKG_CFLAGS) $(PKG_CPPFLAGS) -DMAIN -DX11ARIMA $(LD_LIBS) $< $(LIBSRC) -o $@

	
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
