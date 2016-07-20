// ambientlight.mm
//
// Inspired from: https://bugzilla.mozilla.org/attachment.cgi?id=664102&action=edit
//
// clang -o ambientlight ambientlight.mm -framework IOKit -framework CoreFoundation

#include <mach/mach.h>
#import <IOKit/IOKitLib.h>
#import <CoreFoundation/CoreFoundation.h>

static io_connect_t dataPort = 0;

int main(void) {
  kern_return_t kr;
  io_service_t serviceObject;
  CFRunLoopTimerRef updateTimer;

  serviceObject = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleLMUController"));
  if (!serviceObject) {
    fprintf(stderr, "failed to find ambient light sensors\n");
    exit(1);
  }

  kr = IOServiceOpen(serviceObject, mach_task_self(), 0, &dataPort);
  IOObjectRelease(serviceObject);
  if (kr != KERN_SUCCESS) {
    mach_error("IOServiceOpen:", kr);
    exit(kr);
  }

  setbuf(stdout, NULL);
  //printf("%8ld %8ld", 0L, 0L);

  kern_return_t krr;
  uint32_t outputs = 2;
  uint64_t values[outputs];

  krr = IOConnectCallMethod(dataPort, 0, nil, 0, nil, 0, values, &outputs, nil, 0);
  if (krr == KERN_SUCCESS) {
    printf("%8lld %8lld", values[0], values[1]);
  }

  exit(0);
}
