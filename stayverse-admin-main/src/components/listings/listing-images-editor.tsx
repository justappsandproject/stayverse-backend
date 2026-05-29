import { useRef, useState } from "react";
import { Button } from "@/components/ui/button";
import { ImagePlus, Trash2, Loader2 } from "lucide-react";

const PLACEHOLDER =
  "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='240' height='150' viewBox='0 0 240 150'%3E%3Crect fill='%23e5e7eb' width='240' height='150'/%3E%3Ctext x='50%25' y='50%25' dominant-baseline='middle' text-anchor='middle' fill='%239ca3af' font-family='sans-serif' font-size='14'%3ENo image%3C/text%3E%3C/svg%3E";

type GalleryEditorProps = {
  label: string;
  images: string[];
  onSave: (keepImages: string[], newFiles: File[]) => Promise<boolean>;
  minImages?: number;
};

export function ListingGalleryEditor({
  label,
  images: initialImages,
  onSave,
  minImages = 1,
}: GalleryEditorProps) {
  const fileRef = useRef<HTMLInputElement>(null);
  const [images, setImages] = useState<string[]>(initialImages ?? []);
  const [newFiles, setNewFiles] = useState<File[]>([]);
  const [newPreviews, setNewPreviews] = useState<string[]>([]);
  const [saving, setSaving] = useState(false);
  const [dirty, setDirty] = useState(false);

  const removeExisting = (index: number) => {
    setImages((prev) => prev.filter((_, i) => i !== index));
    setDirty(true);
  };

  const removeNew = (index: number) => {
    setNewFiles((prev) => prev.filter((_, i) => i !== index));
    setNewPreviews((prev) => {
      const url = prev[index];
      if (url) URL.revokeObjectURL(url);
      return prev.filter((_, i) => i !== index);
    });
    setDirty(true);
  };

  const onPickFiles = (e: React.ChangeEvent<HTMLInputElement>) => {
    const picked = Array.from(e.target.files ?? []);
    if (!picked.length) return;
    setNewFiles((prev) => [...prev, ...picked]);
    setNewPreviews((prev) => [...prev, ...picked.map((f) => URL.createObjectURL(f))]);
    setDirty(true);
    e.target.value = "";
  };

  const handleSave = async () => {
    if (images.length + newFiles.length < minImages) {
      return;
    }
    setSaving(true);
    const ok = await onSave(images, newFiles);
    setSaving(false);
    if (ok) {
      setNewFiles([]);
      newPreviews.forEach((u) => URL.revokeObjectURL(u));
      setNewPreviews([]);
      setDirty(false);
    }
  };

  const totalCount = images.length + newFiles.length;
  const canSave = dirty && totalCount >= minImages && !saving;

  return (
    <div className="px-8 py-4 border-t">
      <div className="flex items-center justify-between mb-3">
        <h3 className="font-semibold text-lg">{label}</h3>
        <div className="flex gap-2">
          <input
            ref={fileRef}
            type="file"
            accept="image/jpeg,image/png,image/webp"
            multiple
            className="hidden"
            onChange={onPickFiles}
          />
          <Button type="button" variant="outline" size="sm" onClick={() => fileRef.current?.click()}>
            <ImagePlus className="h-4 w-4 mr-1" />
            Add photos
          </Button>
          <Button type="button" size="sm" disabled={!canSave} onClick={handleSave}>
            {saving ? <Loader2 className="h-4 w-4 animate-spin" /> : "Save images"}
          </Button>
        </div>
      </div>
      <p className="text-xs text-gray-500 mb-3">
        Remove broken photos, add new ones, then save. Apps load images from the CDN URLs stored here.
      </p>
      {totalCount < minImages && (
        <p className="text-xs text-amber-600 mb-2">At least {minImages} image is required.</p>
      )}
      <div className="flex gap-3 overflow-x-auto pb-2">
        {images.map((image, index) => (
          <div key={`existing-${index}`} className="min-w-[200px] h-[130px] relative group">
            <img
              src={image || PLACEHOLDER}
              alt={`Photo ${index + 1}`}
              className="w-full h-full object-cover rounded-md border"
              onError={(e) => {
                (e.target as HTMLImageElement).src = PLACEHOLDER;
              }}
            />
            <button
              type="button"
              className="absolute top-2 right-2 bg-red-600 text-white rounded-full p-1 opacity-90 hover:opacity-100"
              onClick={() => removeExisting(index)}
              aria-label="Remove image"
            >
              <Trash2 className="h-3.5 w-3.5" />
            </button>
          </div>
        ))}
        {newPreviews.map((preview, index) => (
          <div key={`new-${index}`} className="min-w-[200px] h-[130px] relative group">
            <img src={preview} alt={`New ${index + 1}`} className="w-full h-full object-cover rounded-md border border-primary" />
            <span className="absolute top-2 left-2 text-[10px] bg-primary text-white px-1.5 py-0.5 rounded">New</span>
            <button
              type="button"
              className="absolute top-2 right-2 bg-red-600 text-white rounded-full p-1"
              onClick={() => removeNew(index)}
              aria-label="Remove new image"
            >
              <Trash2 className="h-3.5 w-3.5" />
            </button>
          </div>
        ))}
        {totalCount === 0 && (
          <p className="text-sm text-gray-500 py-8">No images yet. Add photos to fix broken listings.</p>
        )}
      </div>
    </div>
  );
}

type ChefPhotosEditorProps = {
  profilePicture: string;
  coverPhoto: string;
  onSave: (files: { profilePicture?: File; coverPhoto?: File }) => Promise<boolean>;
};

export function ChefPhotosEditor({ profilePicture, coverPhoto, onSave }: ChefPhotosEditorProps) {
  const profileRef = useRef<HTMLInputElement>(null);
  const coverRef = useRef<HTMLInputElement>(null);
  const [profileFile, setProfileFile] = useState<File | null>(null);
  const [coverFile, setCoverFile] = useState<File | null>(null);
  const [profilePreview, setProfilePreview] = useState<string | null>(null);
  const [coverPreview, setCoverPreview] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  const pick = (kind: "profile" | "cover", file?: File) => {
    if (!file) return;
    if (kind === "profile") {
      setProfileFile(file);
      setProfilePreview(URL.createObjectURL(file));
    } else {
      setCoverFile(file);
      setCoverPreview(URL.createObjectURL(file));
    }
  };

  const handleSave = async () => {
    if (!profileFile && !coverFile) return;
    setSaving(true);
    const ok = await onSave({
      ...(profileFile && { profilePicture: profileFile }),
      ...(coverFile && { coverPhoto: coverFile }),
    });
    setSaving(false);
    if (ok) {
      setProfileFile(null);
      setCoverFile(null);
      if (profilePreview) URL.revokeObjectURL(profilePreview);
      if (coverPreview) URL.revokeObjectURL(coverPreview);
      setProfilePreview(null);
      setCoverPreview(null);
    }
  };

  return (
    <div className="px-8 py-4 border-t">
      <div className="flex items-center justify-between mb-3">
        <h3 className="font-semibold text-lg">Photos</h3>
        <Button
          type="button"
          size="sm"
          disabled={saving || (!profileFile && !coverFile)}
          onClick={handleSave}
        >
          {saving ? <Loader2 className="h-4 w-4 animate-spin" /> : "Save photos"}
        </Button>
      </div>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <p className="text-sm font-medium mb-2">Profile picture</p>
          <img
            src={profilePreview || profilePicture || PLACEHOLDER}
            alt="Profile"
            className="w-full h-40 object-cover rounded-md border"
            onError={(e) => {
              (e.target as HTMLImageElement).src = PLACEHOLDER;
            }}
          />
          <input
            ref={profileRef}
            type="file"
            accept="image/jpeg,image/png,image/webp"
            className="hidden"
            onChange={(e) => pick("profile", e.target.files?.[0])}
          />
          <Button type="button" variant="outline" size="sm" className="mt-2" onClick={() => profileRef.current?.click()}>
            Replace profile
          </Button>
        </div>
        <div>
          <p className="text-sm font-medium mb-2">Cover photo</p>
          <img
            src={coverPreview || coverPhoto || PLACEHOLDER}
            alt="Cover"
            className="w-full h-40 object-cover rounded-md border"
            onError={(e) => {
              (e.target as HTMLImageElement).src = PLACEHOLDER;
            }}
          />
          <input
            ref={coverRef}
            type="file"
            accept="image/jpeg,image/png,image/webp"
            className="hidden"
            onChange={(e) => pick("cover", e.target.files?.[0])}
          />
          <Button type="button" variant="outline" size="sm" className="mt-2" onClick={() => coverRef.current?.click()}>
            Replace cover
          </Button>
        </div>
      </div>
    </div>
  );
}
