
const char *cadena = "Bienvenido al GOS";

void cls()
{
	unsigned char *vidmem = (unsigned char *)0xB8000;
  	const long size = 80*25;
	long loop;

   	for (loop=0; loop<size; loop++) 
   	{
      		*vidmem++ = 0;
      		*vidmem++ = 0xA;
   	}
}

void print(const char *_message)
{
  unsigned char *vidmem = (unsigned char *)0xB8000;
  const long size = 80*25;
  long loop;
  
  while(*cadena!=0) {
    *vidmem++ = *cadena;
    *vidmem++ = 0x1E;
    *cadena++;
  }
}

int printString()
{
  cls();
  print(cadena);
  return 0;
}


