export default function MetricCard({
  title,
  value,
  fontSize,
  loading = false,
}: {
  title: string;
  value: string;
  fontSize?: string;
  loading?: boolean;
}) {
  return (
    <div className="group w-fit min-w-[160px] h-[140px] flex flex-col justify-center items-center gap-3 p-6 border border-[#DBDBDB] rounded-lg hover:bg-primary-500 hover:text-white bg-white">
      <span className="text-[13px] text-gray-500 group-hover:text-white">{title}</span>
      {loading ? (
        <span
          className="h-10 w-20 rounded-md bg-gray-200 animate-pulse group-hover:bg-white/30"
          aria-hidden
        />
      ) : (
        <span
          className="text-[64px] leading-10 font-bold group-hover:text-white tabular-nums"
          style={{ fontSize: fontSize ?? "64px" }}
        >
          {value}
        </span>
      )}
    </div>
  );
}