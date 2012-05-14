/*cache$B7?G[Ns$r:n$k!#A4MWAG$O$D$M$K(Bmax$B8D$G8GDj!#(Bcache$B$K4^$^$l$J$$MWAG(B */
/*$B$r%"%/%;%9$7$?$i!":G$b5l$$MWAG$r:o=|$7$F>l=j$rDs6!$9$k!#@hFI$_$O$H$j(B */
/*$B$"$($:$7$J$$$3$H$H$9$k!#(B($B@hFI$_$5$;$k$J$i!"(Bdestructor$B$@$1$G$J$/!"%G!<(B */
/*$B%?$rDI2C$9$k$?$a$N4X?t$bI,MW$@$7!"$I$N$h$&$J@oN,$GFI$a$P$$$$$+$o$+$i(B */
/*$B$J$$!#(B)*/

/*$BHs>o$KBg$-$J%-%c%C%7%e$r:n$k>l9g$K$O!"$3$N%W%m%0%i%`$N$h$&$KA0J}$+$i(B */
/*$B=gHV$KC5:w$9$kJ}K!$G$O;~4V$,$+$+$j$9$.$k!#(Bhash$B$HAH$_$"$o$;$k$h$&$J$3(B */
/*$B$H$bI,MW$+$b!#(B*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include "cache.h"

Cache *Cache_Init(int n,void (*destructor)(void *))
{
    Cache *c;
    c = malloc(sizeof(Cache));
    c->destructor = destructor;
    c->n=n;
    c->index=malloc(sizeof(int)*n);
    c->ptr=malloc(sizeof(void *)*n);
    memset(c->index,-1,sizeof(int)*n);
    memset(c->ptr,(intptr_t)NULL,sizeof(void *)*n);
    return c;
}

void **
Cache_ptr(Cache *c,int i)
{
    int j,k;
    for(j=0;j<c->n;j++)
      {
	  if(c->index[j]==i)
	    {
		void *p=c->ptr[j];
#ifdef DEBUG
		fprintf(stderr,"Cache: found at %d\n",j);
#endif 
		for(k=j;k>0;k--)
		  {
		      c->index[k]=c->index[k-1];
		      c->ptr[k]=c->ptr[k-1];
		  }
		c->index[0]=i;
		c->ptr[0]=p;
		return c->ptr;
	    }
      }
#ifdef DEBUG
    fprintf(stderr,"Cache: Not found\n");
#endif 
    j--;
    c->destructor(c->ptr[j]);
    for(k=j;k>0;k--)
      {
	  c->index[k]=c->index[k-1];
	  c->ptr[k]=c->ptr[k-1];
      }
    c->index[0]=i;
    c->ptr[0]=NULL;
    return c->ptr;
}

void Cache_print(Cache *c)
{
    int i;
    for(i=0;i<c->n;i++)
      {
	  printf("%d %lx\n",c->index[i],(intptr_t)(c->ptr[i]));
      }
    printf("\n");
}

/*
void destructor(const void *v)
{
    char *c;
    if(v!=NULL)
      {
	  c=v;
	  printf("%s freed\n",c);
	  free(v);
      }
}
    
int main(int argc,char *argv[])
{
    Cache *c;
    char **i;
    c = Cache_Init(3,destructor);
    Cache_print(c);
    i = Cache_ptr(c,1);
    if((*i)==NULL)
      {
	  (*i)=malloc(sizeof(char)*10);
	  strcpy((*i),"alloc 1");
      }
    Cache_print(c);
    i = Cache_ptr(c,4);
    if((*i)==NULL)
      {
	  (*i)=malloc(sizeof(char)*10);
	  strcpy((*i),"alloc 4");
      }
    Cache_print(c);
    i = Cache_ptr(c,1);
    if((*i)==NULL)
      {
	  (*i)=malloc(sizeof(char)*10);
	  strcpy((*i),"again 1");
      }
    Cache_print(c);
    i = Cache_ptr(c,3);
    if((*i)==NULL)
      {
	  (*i)=malloc(sizeof(char)*10);
	  strcpy((*i),"alloc 3");
      }
    Cache_print(c);
    i = Cache_ptr(c,2);
    if((*i)==NULL)
      {
	  (*i)=malloc(sizeof(char)*10);
	  strcpy((*i),"alloc 2");
      }
    Cache_print(c);
}

    
*/
