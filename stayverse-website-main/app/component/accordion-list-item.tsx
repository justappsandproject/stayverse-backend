import Image from "next/image";

function AccordionListItem({
    id,
    question,
    answer,
  }: {
    id: string;
    question: string;
    answer: string;
  }) {
    return (
      <div className="pb-6 border-b border-b-[#E8E8E8] group animate-fadeIn">
        <input type="checkbox" id={id} className="peer" hidden />
        <label
          htmlFor={id}
          className="w-full mb-3 text-base sm:text-lg leading-6 font-medium text-[#1A191E] cursor-pointer flex items-center justify-between gap-5 peer-checked:[&_img]:rotate-45 transition-transform hover:text-primary-500 duration-300"
        >
          {question}
          <Image
            src={"/svg/plus-icon.svg"}
            width={14}
            height={14}
            alt="plus icon"
            className="transition-transform duration-300"
          />
        </label>
        <div className="max-h-0 peer-checked:max-h-[999px] transition-[max-height] duration-500 ease-in-out overflow-hidden">
          <p className="animate-slideUp text-sm sm:text-base leading-7 text-[#3b3b3b]">{answer}</p>
        </div>
      </div>
    );
  
  
  }
  

  export default AccordionListItem;