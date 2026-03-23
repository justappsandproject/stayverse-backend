

export default function MetricCard({ title, value, fontSize }: { title: string, value: string, fontSize?: string }) {

    return (
        <div className="group w-fit h-[140px] flex flex-col justify-center items-center gap-3 p-6 border border-[#DBDBDB] rounded-lg hover:bg-primary-500 hover:text-white">
            <span className="text-[13px] text-gray-500 group-hover:text-white">{title}</span>
            <span className="text-[64px] leading-10 font-bold group-hover:text-white " style={{ fontSize: fontSize ? fontSize : '64px' }}>{value}</span>
        </div>
    )
}