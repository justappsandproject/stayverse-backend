import { Star } from "lucide-react";


export default function StarRating({ rating, size }: { rating: number, size?: number }) {
    const maxStars = 5;

    return (
        <div className="flex">
            {[...Array(maxStars)].map((_, index) => (
                <Star
                    key={index}
                    size={size || 28}
                    fill={index < Math.round(rating) ? "#F7AD2B" : "#DCDCDC"}
                    stroke={index < Math.round(rating) ? "#F7AD2B" : "#DCDCDC"}
                    strokeWidth={1}
                />
            ))}
        </div>
    );
}