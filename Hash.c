/*$BI8=`E*$J%*!<%W%s%"%I%l%9%O%C%7%e!#M?$($i$l$?MWAG$H%O%C%7%eFb$K$"$kMW(B
  $BAG$NHf3S$r87=E$K9T$($k$h$&$K!"30It4X?t$r8F$S$@$9$h$&$K@_7W$9$k!#(B*/
#include <stdio.h>
#include <stdlib.h>
#include "Hash.h"

/*hash$BMWAG$NHV9f$rJV$9!#$b$7B8:_$7$J$$MWAG$J$i!"6u$-MWAG$rJV$9$,!"%G!<(B
  $B%?$NA^F~$O$7$J$$!#(B*/
int Hash_QueryElement(sHash *h,unsigned int key,void *element)
{
  int dup=0;
  int d=13;
  while(1){
    if(h->value[key]==NULL){
      /*fprintf(stderr,"(emp.%d)",key);*/
      return key;
    }else{
      if(h->_hash_compare(h->value[key],element)==0){
	/*fprintf(stderr,"(ful.%d)",key);*/
	return key;
      }
    }
    key+=d;
    d++;
    dup++;
    /*fprintf(stderr,"(%d:%d)",dup,key);*/
    if(key>=h->hashsize)
      key-=h->hashsize;
  }
}

/*$BCM$rDI2CEPO?$9$k!#$9$G$K%9%m%C%H$,@jM-$5$l$F$$$l$P(B1$B$rJV$9!#(B*/
int Hash_RegisterValue(sHash *h,unsigned int key,void *element)
{
  if(h->value[key]==NULL){
    h->value[key]=element;
    h->nentry++;
    if(h->nentry > h->hashsize/2){
      fprintf(stderr,"Warning: hash size seems too small.\n");
    }
    return 0;
  }else{
    return 1;
  }
}

sHash *Hash_Init(int hashsize,int (*compar)(const void *,const void *))
{
  sHash *h=malloc(sizeof(sHash));
  h->hashsize=hashsize;
  h->value=(void **)calloc(hashsize,sizeof(void *));
  h->nentry=0;
  h->_hash_compare=compar;
  return h;
}

void Hash_Done(sHash *h)
{
  free(h->value);
  free(h);
}
