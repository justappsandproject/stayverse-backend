import Image from "next/image";
import Link from "next/link";

export function AuthBranding({ subtitle }: { subtitle: string }) {
  return (
    <div className="mb-6">
      <Link href="/" className="inline-flex items-center gap-3">
        <Image src="/stayverse-logo.svg" alt="Stayverse logo" width={44} height={44} />
        <div>
          <p className="text-lg font-extrabold leading-none text-[#2C2C2C]">Stayverse</p>
          <p className="mt-1 text-xs font-medium text-[#7D7873]">Apartments, Rides and more</p>
        </div>
      </Link>
      <p className="mt-4 text-sm text-[#2C2C2C]">{subtitle}</p>
    </div>
  );
}
