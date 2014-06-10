require 'facter'
Facter.add(:nova_user) do
  confine :kernel=> :linux
    setcode do
         %x{grep nova /etc/passwd |cut -f1 -d:}.chomp

end
end

