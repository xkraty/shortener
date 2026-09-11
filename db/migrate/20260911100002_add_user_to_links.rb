class AddUserToLinks < ActiveRecord::Migration[8.1]
  def change
    # Nullable: links created before accounts existed keep resolving. Every
    # link created going forward gets one, enforced by Link's belongs_to.
    add_reference :links, :user, foreign_key: { on_delete: :nullify }
  end
end
