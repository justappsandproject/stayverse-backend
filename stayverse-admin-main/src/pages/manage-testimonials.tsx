import {
  TestimonialService,
  type Testimonial,
  type TestimonialPayload,
} from "@/api/testimonial-service";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { useCallback, useEffect, useState } from "react";

const emptyForm: TestimonialPayload = {
  name: "",
  role: "",
  city: "",
  rating: 5,
  quote: "",
  isActive: true,
  sortOrder: 0,
};

export default function ManageTestimonialsPage() {
  const [items, setItems] = useState<Testimonial[]>([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState<TestimonialPayload>(emptyForm);

  const loadItems = useCallback(async () => {
    setLoading(true);
    const data = await TestimonialService.list();
    setItems(data);
    setLoading(false);
  }, []);

  useEffect(() => {
    void loadItems();
  }, [loadItems]);

  const resetForm = () => {
    setEditingId(null);
    setForm(emptyForm);
  };

  const onEdit = (item: Testimonial) => {
    setEditingId(item._id);
    setForm({
      name: item.name,
      role: item.role,
      city: item.city,
      rating: item.rating,
      quote: item.quote,
      isActive: item.isActive,
      sortOrder: item.sortOrder ?? 0,
    });
    window.scrollTo({ top: 0, behavior: "smooth" });
  };

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!form.name.trim() || !form.role.trim() || !form.city.trim() || !form.quote.trim()) {
      return;
    }

    setSaving(true);
    const payload: TestimonialPayload = {
      name: form.name.trim(),
      role: form.role.trim(),
      city: form.city.trim(),
      rating: Number(form.rating),
      quote: form.quote.trim(),
      isActive: form.isActive ?? true,
      sortOrder: Number(form.sortOrder) || 0,
    };

    const result = editingId
      ? await TestimonialService.update(editingId, payload)
      : await TestimonialService.create(payload);

    setSaving(false);
    if (result) {
      resetForm();
      await loadItems();
    }
  };

  const onDelete = async (id: string) => {
    const confirmed = window.confirm("Delete this testimonial?");
    if (!confirmed) return;
    const ok = await TestimonialService.remove(id);
    if (ok) {
      if (editingId === id) resetForm();
      await loadItems();
    }
  };

  const onToggleActive = async (item: Testimonial) => {
    const updated = await TestimonialService.update(item._id, { isActive: !item.isActive });
    if (updated) await loadItems();
  };

  return (
    <section className="px-10 pb-12 pt-[30px] space-y-8">
      <div className="w-full flex items-center gap-5 flex-wrap">
        <h1 className="font-medium text-dark text-[32px]">Website Testimonials</h1>
        <span className="ml-auto text-sm text-[#858585]">
          Manage testimonials shown on the marketing website homepage.
        </span>
      </div>

      <form
        onSubmit={onSubmit}
        className="max-w-4xl bg-white rounded-xl border border-[#ececec] p-6 space-y-4"
      >
        <h2 className="font-medium text-lg">
          {editingId ? "Edit testimonial" : "Add testimonial"}
        </h2>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div className="space-y-2">
            <label className="text-sm font-medium">Name</label>
            <Input
              value={form.name}
              onChange={(e) => setForm((prev) => ({ ...prev, name: e.target.value }))}
              placeholder="Amaka E."
              className="h-11"
              maxLength={80}
              required
            />
          </div>
          <div className="space-y-2">
            <label className="text-sm font-medium">Role</label>
            <Input
              value={form.role}
              onChange={(e) => setForm((prev) => ({ ...prev, role: e.target.value }))}
              placeholder="Frequent traveler"
              className="h-11"
              maxLength={80}
              required
            />
          </div>
          <div className="space-y-2">
            <label className="text-sm font-medium">City</label>
            <Input
              value={form.city}
              onChange={(e) => setForm((prev) => ({ ...prev, city: e.target.value }))}
              placeholder="Lagos"
              className="h-11"
              maxLength={80}
              required
            />
          </div>
          <div className="space-y-2">
            <label className="text-sm font-medium">Rating</label>
            <Select
              value={String(form.rating)}
              onValueChange={(value) =>
                setForm((prev) => ({ ...prev, rating: Number(value) }))
              }
            >
              <SelectTrigger className="w-full h-11">
                <SelectValue placeholder="Select rating" />
              </SelectTrigger>
              <SelectContent>
                {[5, 4, 3, 2, 1].map((rating) => (
                  <SelectItem key={rating} value={String(rating)}>
                    {rating} stars
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <label className="text-sm font-medium">Sort order</label>
            <Input
              type="number"
              value={form.sortOrder}
              onChange={(e) =>
                setForm((prev) => ({ ...prev, sortOrder: Number(e.target.value) }))
              }
              className="h-11"
              min={0}
            />
          </div>
          <div className="space-y-2">
            <label className="text-sm font-medium">Status</label>
            <Select
              value={form.isActive ? "active" : "inactive"}
              onValueChange={(value) =>
                setForm((prev) => ({ ...prev, isActive: value === "active" }))
              }
            >
              <SelectTrigger className="w-full h-11">
                <SelectValue placeholder="Select status" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="active">Active (visible on website)</SelectItem>
                <SelectItem value="inactive">Inactive (hidden)</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>

        <div className="space-y-2">
          <label className="text-sm font-medium">Quote</label>
          <textarea
            value={form.quote}
            onChange={(e) => setForm((prev) => ({ ...prev, quote: e.target.value }))}
            placeholder="Write the testimonial quote..."
            className="w-full min-h-[120px] rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-xs outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]"
            maxLength={500}
            required
          />
        </div>

        <div className="flex items-center gap-3">
          <Button type="submit" disabled={saving}>
            {saving ? "Saving..." : editingId ? "Update testimonial" : "Add testimonial"}
          </Button>
          {editingId && (
            <Button type="button" variant="outline" onClick={resetForm}>
              Cancel edit
            </Button>
          )}
        </div>
      </form>

      <div className="bg-white rounded-xl border border-[#ececec] p-6">
        <div className="flex items-center justify-between mb-4">
          <h2 className="font-medium text-lg">All testimonials</h2>
          <Button type="button" variant="outline" onClick={() => void loadItems()}>
            Refresh
          </Button>
        </div>

        {loading ? (
          <p className="text-sm text-[#858585]">Loading testimonials...</p>
        ) : items.length === 0 ? (
          <p className="text-sm text-[#858585]">No testimonials yet. Add one above.</p>
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Name</TableHead>
                <TableHead>Role / City</TableHead>
                <TableHead>Rating</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Order</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {items.map((item) => (
                <TableRow key={item._id}>
                  <TableCell className="font-medium">{item.name}</TableCell>
                  <TableCell>
                    {item.role} • {item.city}
                  </TableCell>
                  <TableCell>{"★".repeat(item.rating)}</TableCell>
                  <TableCell>
                    <span
                      className={
                        item.isActive
                          ? "text-emerald-700 font-medium"
                          : "text-[#858585] font-medium"
                      }
                    >
                      {item.isActive ? "Active" : "Inactive"}
                    </span>
                  </TableCell>
                  <TableCell>{item.sortOrder ?? 0}</TableCell>
                  <TableCell className="text-right space-x-2">
                    <Button type="button" size="sm" variant="outline" onClick={() => onEdit(item)}>
                      Edit
                    </Button>
                    <Button
                      type="button"
                      size="sm"
                      variant="outline"
                      onClick={() => void onToggleActive(item)}
                    >
                      {item.isActive ? "Hide" : "Show"}
                    </Button>
                    <Button
                      type="button"
                      size="sm"
                      variant="destructive"
                      onClick={() => void onDelete(item._id)}
                    >
                      Delete
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )}
      </div>
    </section>
  );
}
