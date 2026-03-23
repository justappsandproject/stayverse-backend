import { Dialog, DialogContent, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import useModalStore from "@/stores/modal.store";
import { User } from "@/types/user";

export function UserProfileModal() {
  const { open, setOpen, metadata } = useModalStore().userProfileModal;
  const { user } = (metadata as { user: User | null }) || {};

  if (!user) {
    return (
      <Dialog onOpenChange={setOpen} open={open} defaultOpen={open}>
        <DialogContent className="p-6 max-w-3xl">
          <DialogTitle className="sr-only">User Profile</DialogTitle>
          <div className="text-center py-8">
            <p>User information not available</p>
          </div>
        </DialogContent>
      </Dialog>
    );
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogContent className="sm:max-w-xl p-0 gap-0">
        <DialogTitle className="sr-only">User Profile</DialogTitle>
        {/* <DialogHeader className="p-0">
                    <Button variant="ghost" size="icon" className="absolute right-4 top-4 rounded-full h-6 w-6" onClick={() => setOpen(false)}>
                        <X className="h-4 w-4" />
                        <span className="sr-only">Close</span>
                    </Button>
                </DialogHeader> */}

        <div className="flex items-center gap-4 p-6 border-b">
          <div className="h-16 w-16 rounded-full overflow-hidden bg-gray-100 flex items-center justify-center">
            {user.profilePicture ? (
              <img
                src={user.profilePicture || "/placeholder.svg"}
                alt={user.firstname}
                width={64}
                height={64}
                className="h-full w-full object-cover"
              />
            ) : (
              <div className="h-16 w-16 rounded-full bg-gray-200 flex items-center justify-center">
                <svg
                  className="h-8 w-8 text-gray-500"
                  fill="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z" />
                </svg>
              </div>
            )}
          </div>
          <div>
            <h2 className="text-xl font-bold">
              {user.firstname} {user.lastname}
            </h2>
            <p className="text-gray-500">{user.role}</p>
          </div>
        </div>

        <div className="p-6 space-y-4">
          <div className="grid grid-cols-[150px_1fr] gap-y-6">
            <div className="text-gray-700">Email:</div>
            <div className="text-gray-500">{user.email}</div>

            <div className="text-gray-700">Country</div>
            <div className="text-gray-500">{"Nigeria"}</div>

            <div className="text-gray-700">Phone Number</div>
            <div className="text-gray-500">{user.phoneNumber}</div>

            <div className="text-gray-700">NIN</div>
            <div className="text-gray-500">{"—"}</div>
          </div>

          <div className="flex gap-4 pt-4">
            <Button
              className="w-[180px] bg-green-600 hover:bg-green-700 text-white"
              onClick={() => setOpen(false)}
            >
              Approve
            </Button>
            <Button
              className="w-[180px] bg-red-600 hover:bg-red-700 text-white"
              onClick={() => setOpen(false)}
            >
              Decline
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
