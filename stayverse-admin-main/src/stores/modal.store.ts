import { produce } from 'immer';
import { create } from 'zustand';


interface ModalControl {
    open: boolean;
    metadata?: any;
    setOpen: (isOpen: boolean, metadata?: any) => void;
}

const MODAL_NAMES = ['suspendAccountModal', 'deleteAccountModal', 'userProfileModal', 'chefProfileModal', 'apartmentDetails', 'rideDetails'] as const;
type ModalNames = typeof MODAL_NAMES[number];

type ModalState = {
    [key in ModalNames]: ModalControl;
};

const createModalControl = (modalName: ModalNames, set: any): ModalControl => ({
    open: false,
    setOpen: (isOpen, metadata) => {
        set(produce((state: ModalState) => {
            state[modalName].open = isOpen;
            state[modalName].metadata = isOpen ? metadata : undefined;
        }));
    }
});

const useModalStore = create<ModalState>(set => {
    return MODAL_NAMES.reduce((acc, modalName) => {
        acc[modalName] = createModalControl(modalName, set);
        return acc;
    }, {} as ModalState);
});

export default useModalStore;
